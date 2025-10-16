import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class InstructorCourseCard extends StatelessWidget {
  final CourseStatsEntity courseStats;
  final VoidCallback onTap;

  const InstructorCourseCard({
    super.key,
    required this.courseStats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context)!;
    final formatter = Formatter();
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isCompact = screenWidth < 400;
    final isMedium = screenWidth >= 400 && screenWidth < 600;
    final isLarge = screenWidth >= 600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: cs.primary.withOpacity(0.1),
        highlightColor: cs.primary.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.surfaceContainerHighest.withOpacity(0.8),
                cs.surfaceContainer.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cs.primary.withOpacity(0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: cs.shadow.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Decorative background patterns
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          cs.primary.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          cs.secondary.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Main content
                Padding(
                  padding: EdgeInsets.all(isCompact ? 12 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Section: Image + Title + Arrow
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course Thumbnail
                          _buildThumbnail(context, isCompact, isMedium),

                          SizedBox(width: isCompact ? 10 : 14),

                          // Course Info
                          Expanded(
                            child: _buildCourseInfo(
                              context,
                              t,
                              formatter,
                              isCompact,
                            ),
                          ),

                          // Arrow Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: cs.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isCompact ? 12 : 16),

                      // Futuristic divider with glow effect
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              cs.primary.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isCompact ? 12 : 16),

                      // Stats Grid
                      _buildStatsGrid(
                        context,
                        t,
                        formatter,
                        isCompact,
                        isMedium,
                        isLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, bool isCompact, bool isMedium) {
    final cs = Theme.of(context).colorScheme;
    final size = isCompact ? 85.0 : (isMedium ? 100.0 : 110.0);

    return Stack(
      children: [
        // Glow effect behind image
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
        ),

        // Main image container
        Hero(
          tag: 'course_${courseStats.courseId}',
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.primary.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  courseStats.imageUrl != null &&
                      courseStats.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: courseStats.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cs.primaryContainer,
                              cs.primary.withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cs.primaryContainer,
                              cs.primary.withOpacity(0.4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: cs.onPrimaryContainer,
                          size: size * 0.35,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cs.primaryContainer,
                            cs.primary.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: cs.onPrimaryContainer,
                        size: size * 0.45,
                      ),
                    ),
            ),
          ),
        ),

        // Students Badge with futuristic design
        if (courseStats.studentsEnrolled > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              constraints: BoxConstraints(maxWidth: size * 0.5, minWidth: 32),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.primary.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_rounded, size: 10, color: cs.onPrimary),
                  const SizedBox(width: 3),
                  Flexible(
                    child: AutoSizeText(
                      '${courseStats.studentsEnrolled}',
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      minFontSize: 7,
                      maxFontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCourseInfo(
    BuildContext context,
    AppLocalizations t,
    Formatter formatter,
    bool isCompact,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Course Title
        AutoSizeText(
          courseStats.courseTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
            height: 1.2,
            letterSpacing: 0.2,
          ),
          maxLines: 2,
          minFontSize: 12,
          maxFontSize: isCompact ? 14 : 16,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: isCompact ? 6 : 8),

        // Rating Badge
        if (courseStats.totalRatings > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withOpacity(0.2),
                  Colors.amber.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.amber.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                AutoSizeText(
                  courseStats.averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  minFontSize: 9,
                  maxFontSize: 12,
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: AutoSizeText(
                    '(${courseStats.totalRatings})',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 10,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cs.outline.withOpacity(0.3), width: 1),
            ),
            child: AutoSizeText(
              t.no_ratings,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurface.withOpacity(0.5),
                fontStyle: FontStyle.italic,
                fontSize: 10,
              ),
              maxLines: 1,
              minFontSize: 8,
              maxFontSize: 10,
            ),
          ),

        SizedBox(height: isCompact ? 4 : 6),

        // Created Date
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 10,
                color: cs.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: AutoSizeText(
                  formatter.formatDate(courseStats.createdAt, t),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary.withOpacity(0.8),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AppLocalizations t,
    Formatter formatter,
    bool isCompact,
    bool isMedium,
    bool isLarge,
  ) {
    // Determine grid layout based on screen size
    final crossAxisCount = isCompact ? 2 : (isLarge ? 4 : 2);
    final childAspectRatio = isCompact ? 2.5 : (isLarge ? 2.8 : 2.6);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: isCompact ? 8 : 10,
      crossAxisSpacing: isCompact ? 8 : 10,
      childAspectRatio: childAspectRatio,
      children: [
        _buildStatCard(
          context: context,
          icon: Icons.payments_rounded,
          iconColor: Colors.blue,
          label: t.price ?? 'Price',
          value: formatter.formatIqd(courseStats.coursePrice),
          valueColor: Colors.blue,
          gradientColors: [
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        _buildStatCard(
          context: context,
          icon: Icons.trending_up_rounded,
          iconColor: Colors.green,
          label: t.revenue ?? 'Revenue',
          value: formatter.formatIqd(courseStats.totalRevenue),
          valueColor: Colors.green,
          isHighlight: courseStats.totalRevenue > 0,
          gradientColors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        _buildStatCard(
          context: context,
          icon: Icons.people_rounded,
          iconColor: Colors.purple,
          label: t.students,
          value: '${courseStats.studentsEnrolled}',
          valueColor: Colors.purple,
          gradientColors: [
            Colors.purple.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        _buildStatCard(
          context: context,
          icon: Icons.star_rounded,
          iconColor: Colors.amber,
          label: t.ratings,
          value: courseStats.totalRatings > 0
              ? '${courseStats.totalRatings}'
              : '0',
          valueColor: Colors.amber.shade700,
          gradientColors: [
            Colors.amber.withOpacity(0.1),
            Colors.amber.withOpacity(0.05),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
    required List<Color> gradientColors,
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: iconColor.withOpacity(isHighlight ? 0.3 : 0.2),
          width: 1.5,
        ),
        boxShadow: isHighlight
            ? [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 12, color: iconColor),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: AutoSizeText(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  minFontSize: 7,
                  maxFontSize: 9,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Flexible(
            child: AutoSizeText(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              maxLines: 1,
              minFontSize: 9,
              maxFontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
