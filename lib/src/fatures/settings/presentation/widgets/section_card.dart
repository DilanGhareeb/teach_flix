import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // subtle shadow (8% black)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withAlpha(60)),
      ),
      child: Column(children: children),
    );
  }
}
