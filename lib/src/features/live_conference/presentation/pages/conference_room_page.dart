import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_action_buttons.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_status_badge.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/instructor_info_row.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

/// Conference room page that displays conference details and handles purchase/join flow
class ConferenceRoomPage extends StatefulWidget {
  final LiveConference conference;

  const ConferenceRoomPage({super.key, required this.conference});

  @override
  State<ConferenceRoomPage> createState() => _ConferenceRoomPageState();
}

class _ConferenceRoomPageState extends State<ConferenceRoomPage> {
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
    final userId = authBloc.state.user?.id;
    final isInstructor = userId == _currentConference!.instructorId;

    return BlocListener<LiveConferenceBloc, LiveConferenceState>(
      listener: (context, state) =>
          _handleConferenceStateChanges(context, state, l10n),
      child: Scaffold(
        appBar: _buildAppBar(context, l10n, isInstructor),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, l10n),
              const SizedBox(height: 24),
              _buildDescription(context, l10n),
              const SizedBox(height: 24),
              _buildInstructorInfo(context, l10n),
              const SizedBox(height: 24),
              _buildDetailsSection(context, l10n),
              const SizedBox(height: 32),
              // Action buttons with purchase flow
              // Key ensures widget rebuilds when enrolled students change
              ConferenceActionButtons(
                key: ValueKey(_currentConference!.enrolledStudentIds.length),
                conference: _currentConference!,
                isInstructor: isInstructor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
    bool isInstructor,
  ) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.viewDetails),
      elevation: 0,
      actions: [if (isInstructor) _buildDeleteMenu(context, l10n)],
    );
  }

  Widget _buildDeleteMenu(BuildContext context, AppLocalizations l10n) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteConfirmationDialog(context, l10n);
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
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            _currentConference!.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ConferenceStatusBadge(conference: _currentConference!),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.conferenceDescription,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(_currentConference!.description, style: theme.textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildInstructorInfo(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.instructor ?? 'Instructor',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InstructorInfoRow(instructorName: _currentConference!.instructorName),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.conferenceDetails ?? 'Conference Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          context,
          icon: Icons.access_time,
          label: l10n.scheduledTime ?? 'Scheduled Time',
          value: Formatter.formatDateTime(
            context: context,
            _currentConference!.scheduledStartTime,
          ),
        ),
        const SizedBox(height: 12),
        if (_currentConference!.actualStartTime != null)
          _buildDetailRow(
            context,
            icon: Icons.play_circle,
            label: l10n.actualStartTime ?? 'Actual Start Time',
            value: Formatter.formatDateTime(
              context: context,
              _currentConference!.actualStartTime!,
            ),
          ),
        if (_currentConference!.actualStartTime != null)
          const SizedBox(height: 12),
        _buildDetailRow(
          context,
          icon: Icons.timer,
          label: l10n.maxDuration,
          value:
              '${_currentConference!.maxDuration} ${l10n.minutes ?? "minutes"}',
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          context,
          icon: Icons.people,
          label: l10n.participants ?? 'Participants',
          value:
              '${_currentConference!.currentParticipants} / ${_currentConference!.maxParticipants}',
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          context,
          icon: Icons.monetization_on,
          label: l10n.conferencePrice,
          value: _currentConference!.price == 0
              ? l10n.free ?? 'Free'
              : Formatter.formatIqd(_currentConference!.price),
          valueColor: _currentConference!.price > 0
              ? Colors.purple
              : Colors.green,
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _handleConferenceStateChanges(
    BuildContext context,
    LiveConferenceState state,
    AppLocalizations l10n,
  ) {
    // Keep local conference in sync with bloc
    if (state.activeConferences.isNotEmpty) {
      try {
        final updated = state.activeConferences.firstWhere(
          (conf) => conf.id == _currentConference!.id,
        );
        if (mounted && updated != _currentConference) {
          setState(() {
            _currentConference = updated;
          });
        }
      } catch (e) {
        // Conference not found in list (might be deleted or ended)
        // Keep using current conference data
      }
    }

    // Handle purchase success
    if (state.status == LiveConferenceStatus.purchased) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.purchaseSuccess),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      // The conference data will be updated through the stream
      // No need to manually trigger refresh since we're watching active conferences
    }

    // Handle deleted status
    if (state.status == LiveConferenceStatus.deleted) {
      _showSuccessMessage(
        context,
        l10n.conferenceDeleted ?? 'Conference deleted successfully',
      );
      Navigator.pop(context);
    }

    // Handle errors
    if (state.status == LiveConferenceStatus.error && state.failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage(state.failure!, l10n)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getErrorMessage(Failure failure, AppLocalizations l10n) {
    // You can use your ErrorLocalizer here if you have one
    if (failure.toString().contains('insufficient')) {
      return l10n.errInsufficientBalance;
    }
    return l10n.errorOccurred ?? 'An error occurred';
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
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

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
