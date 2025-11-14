import 'package:flutter/material.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class InstructorInfoRow extends StatelessWidget {
  final String instructorName;

  const InstructorInfoRow({super.key, required this.instructorName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, size: 20, color: theme.primaryColor),
        ),
        const SizedBox(width: 8),
        Text(
          '${l10n.instructor}: $instructorName',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
