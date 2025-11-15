import 'package:flutter/material.dart';

/// Debug and error information overlay
class CallDebugInfo extends StatelessWidget {
  final String debugInfo;
  final String? errorText;

  const CallDebugInfo({super.key, required this.debugInfo, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: errorText != null ? _buildErrorView() : _buildDebugView(),
    );
  }

  Widget _buildErrorView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugView() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        debugInfo,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontFamily: 'monospace',
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
