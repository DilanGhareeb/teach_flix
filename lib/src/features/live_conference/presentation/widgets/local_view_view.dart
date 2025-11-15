import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

/// Local user video view (picture-in-picture style)
class LocalVideoView extends StatelessWidget {
  final RtcEngine engine;
  final int? localUid;
  final bool isJoined;

  const LocalVideoView({
    super.key,
    required this.engine,
    required this.localUid,
    required this.isJoined,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.black54,
        child: isJoined ? _buildVideoView() : _buildLoadingView(),
      ),
    );
  }

  Widget _buildVideoView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine,
        canvas: VideoCanvas(
          uid: localUid ?? 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

/// Remote user video view (full screen)
class RemoteVideoView extends StatelessWidget {
  final RtcEngine engine;
  final int? remoteUid;
  final String channelId;
  final String debugInfo;

  const RemoteVideoView({
    super.key,
    required this.engine,
    required this.remoteUid,
    required this.channelId,
    required this.debugInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (remoteUid != null) {
      return _buildRemoteVideo();
    } else {
      return _buildWaitingView();
    }
  }

  Widget _buildRemoteVideo() {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine,
        canvas: VideoCanvas(
          uid: remoteUid,
          renderMode: RenderModeType.renderModeHidden,
        ),
        connection: RtcConnection(channelId: channelId),
      ),
    );
  }

  Widget _buildWaitingView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            const Text(
              'Waiting for others to join...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                debugInfo,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
