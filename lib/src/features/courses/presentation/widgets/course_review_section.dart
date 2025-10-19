import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CourseReviewsSection extends StatelessWidget {
  final CourseEntity course;
  final ColorScheme colorScheme;
  final Future<String> Function(String userId) getUserName;
  final VoidCallback? onViewAllPressed;

  const CourseReviewsSection({
    super.key,
    required this.course,
    required this.colorScheme,
    required this.getUserName,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (course.ratings.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayReviews = course.ratings.take(3).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.student_reviews ?? 'Student Reviews',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (course.ratings.length > 3)
                TextButton.icon(
                  onPressed:
                      onViewAllPressed ??
                      () {
                        // Show snackbar for now
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.coming_soon ?? 'Coming soon!'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(t.view_all ?? 'View All'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayReviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final rating = displayReviews[index];
              return FutureBuilder<String>(
                future: getUserName(rating.userId),
                builder: (context, snapshot) {
                  final userName = snapshot.hasData
                      ? snapshot.data!
                      : snapshot.hasError
                      ? 'User'
                      : '...';

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(
                        0.3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // User Avatar
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: colorScheme.primary,
                              child: snapshot.hasData
                                  ? Text(
                                      userName[0].toUpperCase(),
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_rounded,
                                      color: colorScheme.onPrimary,
                                      size: 24,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      ...List.generate(5, (i) {
                                        return Icon(
                                          i < rating.rating
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          size: 18,
                                          color: Colors.amber[700],
                                        );
                                      }),
                                      const SizedBox(width: 8),
                                      Text(
                                        rating.rating.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Time ago (optional)
                            Text(
                              _getTimeAgo(rating.createdAt, t),
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        if (rating.comment.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            rating.comment,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.8),
                              height: 1.5,
                              fontSize: 15,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime, AppLocalizations t) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return t.just_now ?? 'Just now';
    }
  }
}
