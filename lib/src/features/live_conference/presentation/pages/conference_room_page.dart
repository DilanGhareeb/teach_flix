import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_lobby.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

const String kAgoraAppId = '41e8cb47fddf46febef585956ebb10e4';
const String kAgoraAppCertificate =
    '615b0e10dc6545cc8a125000e07357da'; // <-- add this
const int kTokenExpireSeconds = 60 * 60; // 1 hour

class ConferenceRoomPage extends StatefulWidget {
  final LiveConference conference;

  const ConferenceRoomPage({super.key, required this.conference});

  @override
  State<ConferenceRoomPage> createState() => _ConferenceRoomPageState();
}

class _ConferenceRoomPageState extends State<ConferenceRoomPage> {
  bool _isJoining = false;
  String? _errorMessage;
  LiveConference? _currentConference;

  @override
  void initState() {
    super.initState();
    _currentConference = widget.conference;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;
    final userId = user?.id;
    final userName = user?.name ?? 'User';
    final isInstructor = userId == _currentConference!.instructorId;

    return BlocListener<LiveConferenceBloc, LiveConferenceState>(
      listener: (context, state) {
        // Keep local conference in sync with bloc
        if (state.activeConferences.isNotEmpty) {
          final updated = state.activeConferences.firstWhere(
            (conf) => conf.id == _currentConference!.id,
            orElse: () => _currentConference!,
          );
          if (mounted && updated != _currentConference) {
            setState(() {
              _currentConference = updated;
            });
          }
        }

        // Handle deleted status if your bloc uses it
        if (state.status.toString().contains('deleted')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.conferenceDeleted ?? 'Conference deleted successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentConference!.title),
          elevation: 0,
          actions: [
            if (isInstructor && !(_currentConference!.isLive ?? false)) ...[
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation(context, l10n);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          l10n.deleteConference ?? 'Delete conference',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        body: ConferenceLobby(
          conference: _currentConference!,
          isInstructor: isInstructor,
          isJoining: _isJoining,
          errorMessage: _errorMessage,
          onJoinConference: () =>
              _joinConference(context, userId, userName, isInstructor),
          onStartConference: () => _startConference(context, userId, userName),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteConference ?? 'Delete conference'),
        content: Text(
          l10n.deleteConferenceConfirm ??
              'Are you sure you want to delete this conference? '
                  'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<LiveConferenceBloc>().add(
                DeleteConferenceRequested(_currentConference!.id),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }

  Future<void> _joinConference(
    BuildContext context,
    String? userId,
    String userName,
    bool isInstructor,
  ) async {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;

    if (user == null || userId == null) {
      setState(() {
        _errorMessage = 'User not authenticated';
      });
      return;
    }

    final roomId = _currentConference!.roomId;
    if (roomId.isEmpty) {
      setState(() {
        _errorMessage = 'Conference room is not configured (empty roomId).';
      });
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // For students: mark joined in backend
      if (!isInstructor) {
        context.read<LiveConferenceBloc>().add(
          JoinConferenceRequested(_currentConference!.id),
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      debugPrint(
        '[JOIN] user=$userName, isInstructor=$isInstructor, roomId=$roomId',
      );

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AgoraCallPage(
            channelId: roomId,
            userName: userName,
            isInstructor: isInstructor,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to join conference: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  Future<void> _startConference(
    BuildContext context,
    String? userId,
    String userName,
  ) async {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;

    if (user == null || userId == null) {
      setState(() {
        _errorMessage = 'User not authenticated';
      });
      return;
    }

    final roomId = _currentConference!.roomId;
    if (roomId.isEmpty) {
      setState(() {
        _errorMessage = 'Conference room is not configured (empty roomId).';
      });
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // Instructor marks conference as live in backend
      context.read<LiveConferenceBloc>().add(
        StartConferenceRequested(_currentConference!.id),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      debugPrint('[START] Instructor $userName starting live, roomId=$roomId');

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AgoraCallPage(
            channelId: roomId,
            userName: userName,
            isInstructor: true,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to start conference: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }
}

class AgoraCallPage extends StatefulWidget {
  final String channelId;
  final String userName;
  final bool isInstructor;

  const AgoraCallPage({
    super.key,
    required this.channelId,
    required this.userName,
    required this.isInstructor,
  });

  @override
  State<AgoraCallPage> createState() => _AgoraCallPageState();
}

class _AgoraCallPageState extends State<AgoraCallPage> {
  late final RtcEngine _engine;

  bool _localUserJoined = false;
  int? _remoteUid;
  bool _muted = false;
  bool _cameraOn = true;

  int? _localUid;
  String? _agoraToken;

  String _debugInfo = 'Initializing...';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  void _setDebug(String msg) {
    debugPrint('[AGORA DEBUG] $msg');
    if (!mounted) return;
    setState(() => _debugInfo = msg);
  }

  void _setError(String msg) {
    debugPrint('[AGORA ERROR] $msg');
    if (!mounted) return;
    setState(() {
      _errorText = msg;
      _debugInfo = msg;
    });
  }

  Future<void> _initAgora() async {
    try {
      await [Permission.microphone, Permission.camera].request();

      _setDebug(
        'Init Agora for channel=${widget.channelId}, user=${widget.userName}',
      );

      final uid = Random().nextInt(1 << 31);
      _localUid = uid;
      _setDebug('Generated uid=$uid, building token...');

      final token = RtcTokenBuilder.buildTokenWithUid(
        appId: kAgoraAppId,
        appCertificate: kAgoraAppCertificate,
        channelName: widget.channelId,
        uid: uid,
        tokenExpireSeconds: kTokenExpireSeconds,
      );

      _agoraToken = token;
      _setDebug('Token generated, initializing engine...');

      _engine = createAgoraRtcEngine();

      await _engine.initialize(
        const RtcEngineContext(
          appId: kAgoraAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            _setDebug(
              'onJoinChannelSuccess: localUid=${connection.localUid}, elapsed=$elapsed',
            );
            setState(() => _localUserJoined = true);
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            _setDebug('onUserJoined: remoteUid=$remoteUid, elapsed=$elapsed');
            setState(() => _remoteUid = remoteUid);
          },
          onUserOffline:
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType r,
              ) {
                _setDebug('onUserOffline: remoteUid=$remoteUid, reason=$r');
                setState(() => _remoteUid = null);
              },
          onError: (ErrorCodeType error, String msg) {
            _setError('Agora error: $error\n$msg');
          },
        ),
      );

      await _engine.enableVideo();
      await _engine.startPreview();

      _setDebug('Joining channel ${widget.channelId} with uid=$uid');

      await _engine.joinChannel(
        token: token,
        channelId: widget.channelId,
        uid: uid,
        options: const ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
        ),
      );

      _setDebug('joinChannel() called');
    } catch (e) {
      _setError('Exception during Agora init: $e');
    }
  }

  @override
  void dispose() {
    _leaveAgora();
    super.dispose();
  }

  Future<void> _leaveAgora() async {
    try {
      await _engine.leaveChannel();
      await _engine.release();
    } catch (e) {
      debugPrint('[AGORA] Error while leaving channel: $e');
    }
  }

  void _toggleMute() {
    setState(() => _muted = !_muted);
    _engine.muteLocalAudioStream(_muted);
  }

  void _toggleCamera() {
    setState(() => _cameraOn = !_cameraOn);
    _engine.muteLocalVideoStream(!_cameraOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live call – ${widget.userName}')),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _remoteVideo()),
            Positioned(
              right: 16,
              top: 16,
              width: 120,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(color: Colors.black54, child: _localVideo()),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 90,
              right: 16,
              child: Opacity(
                opacity: 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorText != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errorText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _debugInfo,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleButton(
                    icon: _muted ? Icons.mic_off : Icons.mic,
                    color: _muted ? Colors.red : Colors.white,
                    onTap: _toggleMute,
                  ),
                  const SizedBox(width: 16),
                  _circleButton(
                    icon: _cameraOn ? Icons.videocam : Icons.videocam_off,
                    color: _cameraOn ? Colors.white : Colors.red,
                    onTap: _toggleCamera,
                  ),
                  const SizedBox(width: 16),
                  _circleButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    onTap: () async {
                      await _leaveAgora();
                      if (mounted) Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white24,
        child: Icon(icon, color: color),
      ),
    );
  }

  Widget _localVideo() {
    if (!_localUserJoined) {
      return const Center(child: CircularProgressIndicator());
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: VideoCanvas(
          uid: _localUid ?? 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Waiting for remote user to join...',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _debugInfo,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}
