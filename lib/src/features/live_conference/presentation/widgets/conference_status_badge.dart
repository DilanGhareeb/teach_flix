import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class ConferenceStatusBadge extends StatelessWidget {
  final LiveConference conference;

  const ConferenceStatusBadge({super.key, required this.conference});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = _getStatusInfo(l10n);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (conference.isLive) ...[
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  (String, Color) _getStatusInfo(AppLocalizations l10n) {
    if (conference.isLive) {
      return (l10n.conferenceLive, Colors.red);
    } else if (conference.isScheduled) {
      return (l10n.conferenceScheduled, Colors.orange);
    } else {
      return (l10n.conferenceEnded, Colors.grey);
    }
  }
}
