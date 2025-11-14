import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/pages/conference_room_page.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_action_buttons.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_info_chip.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_status_badge.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/instructor_info_row.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class ConferenceCard extends StatelessWidget {
  final LiveConference conference;

  const ConferenceCard({super.key, required this.conference});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authBloc = context.read<AuthBloc>();
    final userId = authBloc.state.user?.id;
    final isInstructor = userId == conference.instructorId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToRoom(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme, l10n),
              const SizedBox(height: 8),
              _buildDescription(theme),
              const SizedBox(height: 12),
              InstructorInfoRow(instructorName: conference.instructorName),
              const SizedBox(height: 12),
              _buildInfoChips(l10n),
              const SizedBox(height: 16),
              if (conference.isLive)
                ConferenceActionButtons(
                  conference: conference,
                  isInstructor: isInstructor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Text(
            conference.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        ConferenceStatusBadge(conference: conference),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      conference.description,
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoChips(AppLocalizations l10n) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        ConferenceInfoChip(
          icon: Icons.access_time,
          label: Formatter.formatConferenceTime(
            conference.actualStartTime,
            conference.scheduledStartTime,
            conference.isLive,
            conference.hasEnded,
            l10n,
          ),
          color: conference.isLive ? Colors.green : Colors.orange,
        ),
        ConferenceInfoChip(
          icon: Icons.people,
          label: Formatter.formatParticipants(
            conference.currentParticipants,
            conference.maxParticipants,
            l10n,
          ),
          color: conference.isFull ? Colors.red : Colors.blue,
        ),
        ConferenceInfoChip(
          icon: conference.price > 0 ? Icons.attach_money : Icons.card_giftcard,
          label: Formatter.formatIqd(conference.price),
          color: conference.price > 0 ? Colors.purple : Colors.teal,
        ),
      ],
    );
  }

  void _navigateToRoom(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LiveConferenceBloc>(),
          child: ConferenceRoomPage(conference: conference),
        ),
      ),
    );
  }
}
