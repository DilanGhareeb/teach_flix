import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CourseInfoSection extends StatelessWidget {
  final CourseEntity course;
  final ColorScheme colorScheme;

  const CourseInfoSection({
    super.key,
    required this.course,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final totalVideos = course.chapters.fold<int>(
      0,
      (sum, chapter) => sum + chapter.videosUrls.length,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoChip(
                icon: Icons.play_circle_outline,
                label: '$totalVideos ${localizations.lessons ?? "lessons"}',
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 12),
              _InfoChip(
                icon: Icons.menu_book_outlined,
                label: '${course.chapters.length} ${localizations.chapters}',
                colorScheme: colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
