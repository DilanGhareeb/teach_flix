import 'dart:math';
import 'dart:io' show Platform;

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

/// Service to handle all Agora RTC operations with participant tracking and screen sharing
class AgoraService {
  static const String _appId = '41e8cb47fddf46febef585956ebb10e4';
  static const String _appCertificate = '615b0e10dc6545cc8a125000e07357da';
  static const int _tokenExpireSeconds = 60 * 60; // 1 hour

  late final RtcEngine _engine;
  int? _localUid;
  String? _agoraToken;
  bool _isInitialized = false;
  bool _isSharingScreen = false;

  // Participant tracking
  final Map<int, ParticipantInfo> _participants = {};
  String? _localUserName;
  bool _isLocalInstructor = false;

  RtcEngine get engine => _engine;
  int? get localUid => _localUid;
  bool get isInitialized => _isInitialized;
  bool get isSharingScreen => _isSharingScreen;
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
    Function(int uid)? onScreenShareStarted,
    Function(int uid)? onScreenShareStopped,
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
        onScreenShareStarted: onScreenShareStarted,
        onScreenShareStopped: onScreenShareStopped,
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
    Function(int uid)? onScreenShareStarted,
    Function(int uid)? onScreenShareStopped,
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
      onScreenShareStarted: onScreenShareStarted,
      onScreenShareStopped: onScreenShareStopped,
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
    Function(int uid)? onScreenShareStarted,
    Function(int uid)? onScreenShareStopped,
  }) {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          onJoinSuccess(connection.localUid!, elapsed);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
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
              _participants.remove(remoteUid);
              onUserOffline(remoteUid, reason);
            },
        onError: (ErrorCodeType error, String msg) {
          onError('Agora error: $error - $msg');
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
        // Screen sharing events
        onLocalVideoStateChanged:
            (
              VideoSourceType source,
              LocalVideoStreamState state,
              LocalVideoStreamReason error,
            ) {
              if (source == VideoSourceType.videoSourceScreen) {
                if (state ==
                    LocalVideoStreamState.localVideoStreamStateCapturing) {
                  onScreenShareStarted?.call(_localUid ?? 0);
                } else if (state ==
                    LocalVideoStreamState.localVideoStreamStateStopped) {
                  onScreenShareStopped?.call(_localUid ?? 0);
                }
              }
            },
        onRemoteVideoStateChanged:
            (
              RtcConnection connection,
              int remoteUid,
              RemoteVideoState state,
              RemoteVideoStateReason reason,
              int elapsed,
            ) {
              // Detect when remote user starts/stops screen sharing
              if (state == RemoteVideoState.remoteVideoStateDecoding) {
                onScreenShareStarted?.call(remoteUid);
              } else if (state == RemoteVideoState.remoteVideoStateStopped) {
                onScreenShareStopped?.call(remoteUid);
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

  /// Start screen sharing (only instructor is allowed)
  Future<void> startScreenShare() async {
    if (!_isInitialized) {
      throw Exception('Engine not initialized');
    }

    if (!_isLocalInstructor) {
      // Student should not be able to share screen
      const msg = 'Only the instructor can share their screen.';
      debugPrint('[AgoraService] $msg');
      throw Exception(msg);
    }

    try {
      if (Platform.isAndroid) {
        // Android screen share
        await _engine.startScreenCapture(
          const ScreenCaptureParameters2(
            captureAudio: true,
            captureVideo: true,
          ),
        );

        // Update channel to publish screen track
        await _engine.updateChannelMediaOptions(
          const ChannelMediaOptions(
            publishScreenTrack: true,
            publishSecondaryScreenTrack: false,
            publishCameraTrack: false,
            publishMicrophoneTrack: true,
          ),
        );

        _isSharingScreen = true;
        debugPrint('[AgoraService] Screen sharing started');
      } else if (Platform.isIOS) {
        // iOS requires Broadcast Upload Extension
        throw Exception(
          'iOS screen sharing requires Broadcast Upload Extension setup',
        );
      } else {
        throw Exception('Screen sharing not supported on this platform');
      }
    } catch (e) {
      debugPrint('[AgoraService] Failed to start screen share: $e');
      rethrow;
    }
  }

  /// Stop screen sharing
  Future<void> stopScreenShare() async {
    if (!_isInitialized || !_isSharingScreen) {
      return;
    }

    try {
      await _engine.stopScreenCapture();

      // Revert to camera publishing
      await _engine.updateChannelMediaOptions(
        const ChannelMediaOptions(
          publishScreenTrack: false,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
        ),
      );

      _isSharingScreen = false;
      debugPrint('[AgoraService] Screen sharing stopped');
    } catch (e) {
      debugPrint('[AgoraService] Failed to stop screen share: $e');
      rethrow;
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
      if (_isSharingScreen) {
        await stopScreenShare();
      }
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
