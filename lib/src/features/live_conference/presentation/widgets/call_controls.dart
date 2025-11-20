import 'package:flutter/material.dart';
import 'dart:async';

/// Zoom-like call control buttons
class CallControls extends StatefulWidget {
  final bool muted;
  final bool cameraOn;
  final bool showingParticipants;
  final int participantCount;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleCamera;
  final VoidCallback onToggleParticipants;
  final VoidCallback onEndCall;
  final bool isInstructor;

  const CallControls({
    super.key,
    required this.muted,
    required this.cameraOn,
    required this.showingParticipants,
    required this.participantCount,
    required this.onToggleMute,
    required this.onToggleCamera,
    required this.onToggleParticipants,
    required this.onEndCall,
    this.isInstructor = false,
  });

  @override
  State<CallControls> createState() => _CallControlsState();
}

class _CallControlsState extends State<CallControls> {
  Timer? _debounceTimer;
  final Set<String> _processingActions = {};

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleAction(String actionKey, VoidCallback action) {
    // Prevent spam clicking
    if (_processingActions.contains(actionKey)) {
      return;
    }

    setState(() => _processingActions.add(actionKey));
    action();

    // Clear after a short delay
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _processingActions.remove(actionKey));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mute/Unmute
            _ZoomControlButton(
              icon: widget.muted ? Icons.mic_off : Icons.mic,
              label: widget.muted ? 'Unmute' : 'Mute',
              isActive: !widget.muted,
              color: widget.muted ? Colors.red : Colors.white,
              onTap: () => _handleAction('mute', widget.onToggleMute),
              isProcessing: _processingActions.contains('mute'),
            ),

            const SizedBox(width: 12),

            // Camera On/Off (everyone can toggle, including instructor)
            _ZoomControlButton(
              icon: widget.cameraOn ? Icons.videocam : Icons.videocam_off,
              label: widget.cameraOn ? 'Stop Video' : 'Start Video',
              isActive: widget.cameraOn,
              color: widget.cameraOn ? Colors.white : Colors.red,
              onTap: () => _handleAction('camera', widget.onToggleCamera),
              isProcessing: _processingActions.contains('camera'),
            ),

            const SizedBox(width: 12),

            // Participants
            _ZoomControlButton(
              icon: Icons.people,
              label: 'Participants',
              isActive: widget.showingParticipants,
              badge: widget.participantCount.toString(),
              onTap: () =>
                  _handleAction('participants', widget.onToggleParticipants),
              isProcessing: _processingActions.contains('participants'),
            ),

            const SizedBox(width: 12),

            // End Call
            _ZoomControlButton(
              icon: Icons.call_end,
              label: 'Leave',
              color: Colors.white,
              backgroundColor: Colors.red,
              onTap: () => _handleAction('endCall', widget.onEndCall),
              isProcessing: _processingActions.contains('endCall'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? backgroundColor;
  final bool isActive;
  final String? badge;
  final VoidCallback? onTap;
  final bool isProcessing;

  const _ZoomControlButton({
    required this.icon,
    required this.label,
    this.color = Colors.white,
    this.backgroundColor,
    this.isActive = false,
    this.badge,
    required this.onTap,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool canTap = onTap != null && !isProcessing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color:
                  backgroundColor ??
                  (isActive
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                onTap: canTap ? onTap : null,
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: isActive
                        ? Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          )
                        : null,
                  ),
                  child: isProcessing
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Icon(icon, color: color, size: 28),
                ),
              ),
            ),
            if (badge != null)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
