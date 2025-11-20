import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Participant information model
class ParticipantInfo {
  final int uid;
  final String name;
  final bool isInstructor;
  final bool isMuted;
  final bool hasVideo;

  ParticipantInfo({
    required this.uid,
    required this.name,
    this.isInstructor = false,
    this.isMuted = false,
    this.hasVideo = true,
  });

  ParticipantInfo copyWith({
    String? name,
    bool? isInstructor,
    bool? isMuted,
    bool? hasVideo,
  }) {
    return ParticipantInfo(
      uid: uid,
      name: name ?? this.name,
      isInstructor: isInstructor ?? this.isInstructor,
      isMuted: isMuted ?? this.isMuted,
      hasVideo: hasVideo ?? this.hasVideo,
    );
  }
}

/// Service to handle all Agora RTC operations with participant tracking
class AgoraService {
  static const String _appId = '41e8cb47fddf46febef585956ebb10e4';
  static const String _appCertificate = '615b0e10dc6545cc8a125000e07357da';
  static const int _tokenExpireSeconds = 60 * 60; // 1 hour

  late final RtcEngine _engine;
  int? _localUid;
  String? _agoraToken;
  bool _isInitialized = false;

  // Participant tracking
  final Map<int, ParticipantInfo> _participants = {};
  String? _localUserName;
  bool _isLocalInstructor = false;

  RtcEngine get engine => _engine;
  int? get localUid => _localUid;
  bool get isInitialized => _isInitialized;
  Map<int, ParticipantInfo> get participants => Map.unmodifiable(_participants);
  String? get localUserName => _localUserName;
  bool get isLocalInstructor => _isLocalInstructor;

  /// Initialize Agora engine and join channel with participant info
  Future<void> initialize({
    required String channelId,
    required String userName,
    required bool isInstructor,
    required Function(int localUid, int elapsed) onJoinSuccess,
    required Function(ParticipantInfo participant, int elapsed) onUserJoined,
    required Function(int remoteUid, UserOfflineReasonType reason)
    onUserOffline,
    required Function(String error) onError,
    required Function(String info) onDebugInfo,
  }) async {
    try {
      _localUserName = userName;
      _isLocalInstructor = isInstructor;

      // Request permissions
      await _requestPermissions();
      onDebugInfo('Permissions granted');

      // Generate UID and token
      _localUid = _generateUid();
      onDebugInfo('Generated UID: $_localUid');

      // Store local participant info
      _participants[_localUid!] = ParticipantInfo(
        uid: _localUid!,
        name: userName,
        isInstructor: isInstructor,
      );

      _agoraToken = _generateToken(channelId, _localUid!);
      onDebugInfo('Token generated');

      // Initialize engine
      await _initializeEngine(
        channelId: channelId,
        onJoinSuccess: onJoinSuccess,
        onUserJoined: onUserJoined,
        onUserOffline: onUserOffline,
        onError: onError,
      );
      onDebugInfo('Engine initialized');

      // Join channel
      await _joinChannel(channelId, _agoraToken!);
      onDebugInfo('Joining channel: $channelId');

      _isInitialized = true;
    } catch (e) {
      onError('Initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _requestPermissions() async {
    final statuses = await [Permission.microphone, Permission.camera].request();

    final allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      throw Exception('Permissions not granted');
    }
  }

  int _generateUid() {
    return Random().nextInt(1 << 31);
  }

  String _generateToken(String channelName, int uid) {
    return RtcTokenBuilder.buildTokenWithUid(
      appId: _appId,
      appCertificate: _appCertificate,
      channelName: channelName,
      uid: uid,
      tokenExpireSeconds: _tokenExpireSeconds,
    );
  }

  Future<void> _initializeEngine({
    required String channelId,
    required Function(int localUid, int elapsed) onJoinSuccess,
    required Function(ParticipantInfo participant, int elapsed) onUserJoined,
    required Function(int remoteUid, UserOfflineReasonType reason)
    onUserOffline,
    required Function(String error) onError,
  }) async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      const RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _registerEventHandlers(
      channelId: channelId,
      onJoinSuccess: onJoinSuccess,
      onUserJoined: onUserJoined,
      onUserOffline: onUserOffline,
      onError: onError,
    );

    await _engine.enableVideo();
    await _engine.startPreview();
  }

  void _registerEventHandlers({
    required String channelId,
    required Function(int localUid, int elapsed) onJoinSuccess,
    required Function(ParticipantInfo participant, int elapsed) onUserJoined,
    required Function(int remoteUid, UserOfflineReasonType reason)
    onUserOffline,
    required Function(String error) onError,
  }) {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
            '[AgoraService] Joined channel ${connection.channelId} '
            'as ${connection.localUid}',
          );
          onJoinSuccess(connection.localUid!, elapsed);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('[AgoraService] User joined: $remoteUid');

          final participant = ParticipantInfo(
            uid: remoteUid,
            name: 'User $remoteUid',
            isInstructor: false,
          );
          _participants[remoteUid] = participant;
          onUserJoined(participant, elapsed);
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              debugPrint(
                '[AgoraService] User offline: $remoteUid, reason: $reason',
              );
              _participants.remove(remoteUid);
              onUserOffline(remoteUid, reason);
            },
        onError: (ErrorCodeType error, String msg) {
          final message = 'Agora error: $error - $msg';
          debugPrint('[AgoraService] $message');
          onError(message);
        },
        onUserInfoUpdated: (int uid, UserInfo info) {
          debugPrint(
            '[AgoraService] User info updated: uid=$uid, account=${info.userAccount}',
          );
          if (_participants.containsKey(uid)) {
            if (info.userAccount != null && info.userAccount!.isNotEmpty) {
              _participants[uid] = _participants[uid]!.copyWith(
                name: info.userAccount,
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _joinChannel(String channelId, String token) async {
    await _engine.joinChannel(
      token: token,
      channelId: channelId,
      uid: _localUid!,
      options: ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: _isLocalInstructor
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience,
      ),
    );

    try {
      await _engine.registerLocalUserAccount(
        appId: _appId,
        userAccount: _localUserName ?? 'User $_localUid',
      );
    } catch (e) {
      debugPrint('[AgoraService] Failed to register user account: $e');
    }
  }

  /// Update participant information (e.g., from backend)
  void updateParticipant(
    int uid, {
    String? name,
    bool? isInstructor,
    bool? isMuted,
    bool? hasVideo,
  }) {
    if (_participants.containsKey(uid)) {
      _participants[uid] = _participants[uid]!.copyWith(
        name: name,
        isInstructor: isInstructor,
        isMuted: isMuted,
        hasVideo: hasVideo,
      );
    }
  }

  /// Get participant info by UID
  ParticipantInfo? getParticipant(int uid) {
    return _participants[uid];
  }

  /// Get all participants except local user
  List<ParticipantInfo> getRemoteParticipants() {
    return _participants.values.where((p) => p.uid != _localUid).toList();
  }

  /// Toggle microphone mute state
  Future<void> toggleMute(bool muted) async {
    await _engine.muteLocalAudioStream(muted);
    if (_localUid != null && _participants.containsKey(_localUid)) {
      _participants[_localUid!] = _participants[_localUid!]!.copyWith(
        isMuted: muted,
      );
    }
  }

  /// Toggle camera on/off
  Future<void> toggleCamera(bool cameraOn) async {
    await _engine.muteLocalVideoStream(!cameraOn);
    if (_localUid != null && _participants.containsKey(_localUid)) {
      _participants[_localUid!] = _participants[_localUid!]!.copyWith(
        hasVideo: cameraOn,
      );
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    await _engine.switchCamera();
  }

  /// Leave channel and release resources
  Future<void> leaveChannel() async {
    if (!_isInitialized) return;

    try {
      await _engine.leaveChannel();
      await _engine.release();
      _isInitialized = false;
      _participants.clear();
      _localUid = null;
    } catch (e) {
      debugPrint('[AgoraService] Error leaving channel: $e');
    }
  }

  /// Renew token if needed (call before token expires)
  Future<void> renewToken(String channelId) async {
    if (_localUid == null) return;

    _agoraToken = _generateToken(channelId, _localUid!);
    await _engine.renewToken(_agoraToken!);
  }
}
