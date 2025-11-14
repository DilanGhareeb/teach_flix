import 'package:flutter/material.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class JoinTimeWarning extends StatelessWidget {
  final LiveConference conference;

  const JoinTimeWarning({super.key, required this.conference});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remainingMinutes = Formatter.calculateRemainingJoinMinutes(
      conference.actualStartTime,
    );

    if (remainingMinutes <= 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              l10n.joinWindowClosed,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Text(
        l10n.youCanJoinFor(remainingMinutes.toString()),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.orange[800],
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
