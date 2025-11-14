// conference_lobby.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class ConferenceLobby extends StatelessWidget {
  final LiveConference conference;
  final bool isInstructor;
  final bool isJoining;
  final String? errorMessage;
  final VoidCallback onJoinConference;
  final VoidCallback onStartConference;

  const ConferenceLobby({
    super.key,
    required this.conference,
    required this.isInstructor,
    required this.isJoining,
    required this.errorMessage,
    required this.onJoinConference,
    required this.onStartConference,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Conference Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.video_call, size: 80, color: theme.primaryColor),
          ),
          const SizedBox(height: 32),

          // Conference Title
          Text(
            conference.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Conference Description
          Text(
            conference.description,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Conference Details Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.person,
                    l10n.instructor,
                    conference.instructorName,
                    theme,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    Icons.people,
                    l10n.participants,
                    Formatter.formatParticipants(
                      conference.currentParticipants,
                      conference.maxParticipants,
                      l10n,
                    ),
                    theme,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    Icons.timer,
                    l10n.duration ?? 'Duration',
                    '${conference.maxDuration} ${l10n.minutes ?? "minutes"}',
                    theme,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    Icons.monetization_on,
                    l10n.conferencePrice ?? 'Price',
                    conference.price > 0
                        ? Formatter.formatIqd(conference.price)
                        : l10n.free ?? 'Free',
                    theme,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    Icons.meeting_room,
                    l10n.roomId ?? 'Room ID',
                    conference.roomId,
                    theme,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Error Message
          if (errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Action Buttons
          if (isInstructor) ...[
            _buildInstructorButtons(context, l10n),
          ] else ...[
            _buildStudentButton(context, l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 24, color: theme.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructorButtons(BuildContext context, AppLocalizations l10n) {
    // Show different buttons based on conference status
    if (!conference.isLive && conference.isScheduled) {
      // Conference not started yet - show Start button
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: isJoining ? null : onStartConference,
          icon: isJoining
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.play_circle, size: 28),
          label: Text(
            l10n.startConference,
            style: const TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    if (conference.isLive) {
      // Conference is live - show Join and End buttons
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: isJoining ? null : onJoinConference,
              icon: isJoining
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.video_call, size: 28),
              label: Text(
                l10n.joinConference,
                style: const TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: isJoining
                  ? null
                  : () => _showEndConferenceDialog(context, l10n),
              icon: const Icon(Icons.stop_circle, size: 28),
              label: Text(
                l10n.endConference,
                style: const TextStyle(fontSize: 18),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Conference has ended
    return _buildNotLiveMessage(context, l10n);
  }

  Widget _buildStudentButton(BuildContext context, AppLocalizations l10n) {
    if (!conference.isLive) {
      return _buildNotLiveMessage(context, l10n);
    }

    if (!conference.canJoin) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.joinWindowClosed,
                style: TextStyle(
                  color: Colors.orange[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (conference.isFull) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.group_off, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.conferenceFull,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isJoining ? null : onJoinConference,
        icon: isJoining
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.video_call, size: 28),
        label: Text(l10n.joinConference, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildNotLiveMessage(BuildContext context, AppLocalizations l10n) {
    String message;
    IconData icon;

    if (conference.hasEnded) {
      message = l10n.conferenceEnded;
      icon = Icons.stop_circle;
    } else if (conference.isScheduled) {
      message = l10n.conferenceNotStarted ?? 'Conference has not started yet';
      icon = Icons.schedule;
    } else {
      message = l10n.conferenceNotAvailable ?? 'Conference is not available';
      icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEndConferenceDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.endConference),
        content: Text(
          l10n.endConferenceConfirm ??
              'Are you sure you want to end this conference? This will disconnect all participants.',
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
                EndConferenceRequested(conference.id),
              );
              Navigator.pop(context); // Go back to conferences list
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }
}
