import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/live_conference/data/services/agora_service.dart';
import 'package:teach_flix/src/features/live_conference/data/services/conference_participant_sync.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/call_controls.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/call_header.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/participant_list.dart';

/// Zoom-like video call with instructor prominence and real names
class AgoraCallPage extends StatefulWidget {
  final String conferenceId;
  final String channelId;
  final String userId;
  final String userName;
  final bool isInstructor;

  const AgoraCallPage({
    super.key,
    required this.conferenceId,
    required this.channelId,
    required this.userId,
    required this.userName,
    required this.isInstructor,
  });

  @override
  State<AgoraCallPage> createState() => _AgoraCallPageState();
}

class _AgoraCallPageState extends State<AgoraCallPage> {
  late final AgoraService _agoraService;
  late final ConferenceParticipantSync _participantSync;
  StreamSubscription<List<ParticipantData>>? _participantSubscription;

  bool _localUserJoined = false;
  Map<int, ParticipantData> _participants = {};
  int? _instructorUid;
  bool _muted = false;
  bool _cameraOn = true;
  bool _showParticipants = false;
  bool _isFullScreen = false;

  // Who is shown in the main big view (for instructor)
  int? _selectedMainUid;

  String _debugInfo = 'Initializing...';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _agoraService = AgoraService();
    _participantSync = ConferenceParticipantSync();
    _initializeCall();
  }

  @override
  void dispose() {
    _participantSubscription?.cancel();
    _participantSync.leaveConference(
      conferenceId: widget.conferenceId,
      userId: widget.userId,
    );
    _agoraService.leaveChannel();
    super.dispose();
  }

  Future<void> _initializeCall() async {
    try {
      // Initialize Agora
      await _agoraService.initialize(
        channelId: widget.channelId,
        userName: widget.userName,
        isInstructor: widget.isInstructor,
        onJoinSuccess: _handleJoinSuccess,
        onUserJoined: _handleUserJoined,
        onUserOffline: _handleUserOffline,
        onError: _handleError,
        onDebugInfo: _updateDebugInfo,
      );

      // Register in Firebase
      await _participantSync.joinConference(
        conferenceId: widget.conferenceId,
        userId: widget.userId,
        userName: widget.userName,
        agoraUid: _agoraService.localUid!,
        isInstructor: widget.isInstructor,
      );

      // Watch for participant updates
      _startWatchingParticipants();
    } catch (e) {
      _setError('Failed to initialize call: $e');
    }
  }

  void _startWatchingParticipants() {
    _participantSubscription = _participantSync
        .watchParticipants(widget.conferenceId)
        .listen((participants) {
          if (mounted) {
            setState(() {
              // Convert list to map with UID as key
              _participants = {for (var p in participants) p.agoraUid: p};

              // Find instructor UID
              if (_participants.isNotEmpty) {
                _instructorUid = _participants.entries
                    .firstWhere(
                      (entry) => entry.value.isInstructor,
                      orElse: () => MapEntry(
                        _participants.keys.first,
                        _participants.values.first,
                      ),
                    )
                    .key;
              } else {
                _instructorUid = null;
              }
            });
          }
        });
  }

  void _handleJoinSuccess(int localUid, int elapsed) {
    _updateDebugInfo('Connected to conference');
    setState(() => _localUserJoined = true);
  }

  void _handleUserJoined(ParticipantInfo participant, int elapsed) {
    _updateDebugInfo('${participant.name} joined');
  }

  void _handleUserOffline(int remoteUid, UserOfflineReasonType reason) {
    _updateDebugInfo('Participant left');
  }

  void _handleError(String error) {
    _setError(error);
  }

  void _updateDebugInfo(String info) {
    debugPrint('[AGORA] $info');
    if (mounted) {
      setState(() => _debugInfo = info);
    }
  }

  void _setError(String message) {
    debugPrint('[AGORA ERROR] $message');
    if (mounted) {
      setState(() {
        _errorText = message;
        _debugInfo = message;
      });
    }
  }

  void _toggleMute() {
    setState(() => _muted = !_muted);
    _agoraService.toggleMute(_muted);
    _participantSync.updateStatus(
      conferenceId: widget.conferenceId,
      userId: widget.userId,
      isMuted: _muted,
    );
  }

  void _toggleCamera() {
    setState(() => _cameraOn = !_cameraOn);
    _agoraService.toggleCamera(_cameraOn);
    _participantSync.updateStatus(
      conferenceId: widget.conferenceId,
      userId: widget.userId,
      hasVideo: _cameraOn,
    );
  }

  void _toggleParticipants() {
    setState(() => _showParticipants = !_showParticipants);
  }

  Future<void> _endCall() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Conference?'),
        content: const Text('Are you sure you want to leave this conference?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (shouldEnd == true) {
      await _participantSync.leaveConference(
        conferenceId: widget.conferenceId,
        userId: widget.userId,
      );
      await _agoraService.leaveChannel();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _endCall();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        body: SafeArea(
          child: Stack(
            children: [
              // Main video area
              Positioned.fill(child: _buildVideoArea()),

              // Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CallHeader(
                  channelId: widget.channelId,
                  userName: widget.userName,
                  participantCount: _participants.length,
                  debugInfo: _debugInfo,
                  errorText: _errorText,
                  onToggleFullScreen: () {
                    setState(() => _isFullScreen = !_isFullScreen);
                  },
                ),
              ),

              // Bottom controls
              if (!_isFullScreen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: CallControls(
                      muted: _muted,
                      cameraOn: _cameraOn,
                      showingParticipants: _showParticipants,
                      participantCount: _participants.length,
                      onToggleMute: _toggleMute,
                      onToggleCamera: _toggleCamera,
                      onToggleParticipants: _toggleParticipants,
                      onEndCall: _endCall,
                      isInstructor: widget.isInstructor,
                    ),
                  ),
                ),

              // Participants panel
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 0,
                bottom: 0,
                right: _showParticipants ? 0 : -280,
                width: 280,
                child: ParticipantList(
                  participants: _participants.values.toList(),
                  localUid: _agoraService.localUid ?? 0,
                  isInstructor: widget.isInstructor,
                  onClose: () => setState(() => _showParticipants = false),
                  selectedUid: _selectedMainUid,
                  onSelectParticipant: widget.isInstructor
                      ? (uid) {
                          setState(() {
                            _selectedMainUid = uid;
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoArea() {
    final remoteParticipants = _participants.entries
        .where((entry) => entry.key != _agoraService.localUid)
        .toList();

    // Just you waiting
    if (remoteParticipants.isEmpty) {
      return _buildWaitingView();
    }

    // Decide who is in the main view
    int prominentUid;
    if (widget.isInstructor) {
      // Instructor can choose anyone; default to self
      prominentUid = _selectedMainUid ?? (_agoraService.localUid ?? 0);
    } else if (_instructorUid != null) {
      // Students: see instructor by default
      prominentUid = _selectedMainUid ?? _instructorUid!;
    } else {
      // Fallback
      prominentUid = _selectedMainUid ?? remoteParticipants.first.key;
    }

    return _buildInstructorProminentView(prominentUid, remoteParticipants);
  }

  Widget _buildWaitingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  if (_localUserJoined)
                    AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _agoraService.engine,
                        // Local preview: always uid 0
                        canvas: const VideoCanvas(
                          uid: 0,
                          renderMode: RenderModeType.renderModeHidden,
                        ),
                      ),
                    )
                  else
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  // Name overlay
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isInstructor)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'HOST',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Flexible(
                            child: Text(
                              widget.userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Waiting for others to join...',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorProminentView(
    int prominentUid,
    List<MapEntry<int, ParticipantData>> remoteParticipants,
  ) {
    final prominentParticipant = _participants[prominentUid];
    final isProminentLocal = prominentUid == _agoraService.localUid;

    // Other participants thumbnails
    final otherParticipants = <MapEntry<int, ParticipantData>>[
      if (_agoraService.localUid != null &&
          _participants.containsKey(_agoraService.localUid) &&
          !isProminentLocal)
        MapEntry(
          _agoraService.localUid!,
          _participants[_agoraService.localUid]!,
        ),
      ...remoteParticipants.where((entry) => entry.key != prominentUid),
    ];

    return Column(
      children: [
        // Main big view
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: prominentParticipant?.isInstructor == true
                  ? Border.all(color: Colors.orange, width: 3)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  if (isProminentLocal)
                    // Local main view: uid 0, camera source
                    AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _agoraService.engine,
                        canvas: const VideoCanvas(
                          uid: 0,
                          renderMode: RenderModeType.renderModeHidden,
                        ),
                      ),
                    )
                  else
                    // Remote user
                    AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _agoraService.engine,
                        canvas: VideoCanvas(
                          uid: prominentUid,
                          renderMode: RenderModeType.renderModeHidden,
                        ),
                        connection: RtcConnection(channelId: widget.channelId),
                      ),
                    ),

                  // Name overlay
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: _buildNameTag(
                      prominentParticipant?.userName ?? 'Unknown',
                      prominentParticipant?.isInstructor ?? false,
                      isProminentLocal,
                      prominentParticipant?.isMuted ?? false,
                      prominentParticipant?.hasVideo ?? true,
                      isLarge: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Thumbnails strip
        if (otherParticipants.isNotEmpty)
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: otherParticipants.length,
              itemBuilder: (context, index) {
                final entry = otherParticipants[index];
                final uid = entry.key;
                final participant = entry.value;
                final isLocal = uid == _agoraService.localUid;

                return GestureDetector(
                  onTap: () {
                    if (widget.isInstructor) {
                      setState(() {
                        _selectedMainUid = uid;
                      });
                    }
                  },
                  child: _buildThumbnail(
                    uid: uid,
                    participant: participant,
                    isLocal: isLocal,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildGridView(
    List<MapEntry<int, ParticipantData>> remoteParticipants,
  ) {
    final allParticipants = <MapEntry<int, ParticipantData>>[];

    if (_agoraService.localUid != null &&
        _participants.containsKey(_agoraService.localUid)) {
      allParticipants.add(
        MapEntry(
          _agoraService.localUid!,
          _participants[_agoraService.localUid]!,
        ),
      );
    }

    allParticipants.addAll(remoteParticipants);

    if (allParticipants.isEmpty) {
      return const SizedBox.shrink();
    }

    final crossAxisCount = allParticipants.length <= 4 ? 2 : 3;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: allParticipants.length,
      itemBuilder: (context, index) {
        final entry = allParticipants[index];
        final uid = entry.key;
        final participant = entry.value;
        final isLocal = uid == _agoraService.localUid;

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: participant.isInstructor == true
                ? Border.all(color: Colors.orange, width: 2)
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Video
                isLocal
                    // Local in grid: uid 0
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _agoraService.engine,
                          canvas: const VideoCanvas(
                            uid: 0,
                            renderMode: RenderModeType.renderModeHidden,
                          ),
                        ),
                      )
                    : AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _agoraService.engine,
                          canvas: VideoCanvas(
                            uid: uid,
                            renderMode: RenderModeType.renderModeHidden,
                          ),
                          connection: RtcConnection(
                            channelId: widget.channelId,
                          ),
                        ),
                      ),
                // Name tag
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: _buildNameTag(
                    participant.userName ?? 'Unknown',
                    participant.isInstructor ?? false,
                    isLocal,
                    participant.isMuted ?? false,
                    participant.hasVideo ?? true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThumbnail({
    required int uid,
    required ParticipantData? participant,
    required bool isLocal,
  }) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: participant?.isInstructor == true
              ? Colors.orange
              : Colors.white24,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            // Video
            isLocal
                // Local thumb: uid 0
                ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _agoraService.engine,
                      canvas: const VideoCanvas(
                        uid: 0,
                        renderMode: RenderModeType.renderModeHidden,
                      ),
                    ),
                  )
                : AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _agoraService.engine,
                      canvas: VideoCanvas(
                        uid: uid,
                        renderMode: RenderModeType.renderModeHidden,
                      ),
                      connection: RtcConnection(channelId: widget.channelId),
                    ),
                  ),
            // Name
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  participant?.userName ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameTag(
    String name,
    bool isInstructor,
    bool isYou,
    bool isMuted,
    bool hasVideo, {
    bool isLarge = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12 : 8,
        vertical: isLarge ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(isLarge ? 8 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isInstructor)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'HOST',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLarge ? 10 : 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Flexible(
            child: Text(
              isYou ? '$name (You)' : name,
              style: TextStyle(
                color: Colors.white,
                fontSize: isLarge ? 16 : 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isMuted) ...[
            const SizedBox(width: 6),
            Icon(Icons.mic_off, color: Colors.red, size: isLarge ? 16 : 12),
          ],
          if (!hasVideo) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.videocam_off,
              color: Colors.red,
              size: isLarge ? 16 : 12,
            ),
          ],
        ],
      ),
    );
  }
}
