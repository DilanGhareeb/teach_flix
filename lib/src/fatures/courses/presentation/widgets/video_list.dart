import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosList extends StatelessWidget {
  final CourseEntity course;
  final VideoEntity? selectedVideo;
  final YoutubePlayerController? youtubeController;
  final Function(VideoEntity) onVideoTap;
  final ColorScheme colorScheme;

  const VideosList({
    super.key,
    required this.course,
    required this.selectedVideo,
    required this.youtubeController,
    required this.onVideoTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: course.chapters.length,
      itemBuilder: (context, chapterIndex) {
        final chapter = course.chapters[chapterIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chapterIndex > 0) const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      chapter.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${chapter.videosUrls.length}',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...chapter.videosUrls.map((video) {
              final isSelected = selectedVideo?.id == video.id;
              final isPlaying =
                  isSelected &&
                  youtubeController != null &&
                  youtubeController!.value.isPlaying;

              return VideoCard(
                video: video,
                isSelected: isSelected,
                isPlaying: isPlaying,
                onTap: () => onVideoTap(video),
                colorScheme: colorScheme,
                localizations: localizations,
              );
            }),
          ],
        );
      },
    );
  }
}

// Video Card Widget
class VideoCard extends StatelessWidget {
  final VideoEntity video;
  final bool isSelected;
  final bool isPlaying;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final AppLocalizations localizations;

  const VideoCard({
    super.key,
    required this.video,
    required this.isSelected,
    required this.isPlaying,
    required this.onTap,
    required this.colorScheme,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withOpacity(0.3)
            : colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [
                              colorScheme.primary,
                              colorScheme.primary.withOpacity(0.7),
                            ]
                          : [
                              colorScheme.primaryContainer,
                              colorScheme.primaryContainer.withOpacity(0.7),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isSelected
                                    ? colorScheme.primary
                                    : colorScheme.primaryContainer)
                                .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: isSelected
                        ? Colors.white
                        : colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              localizations.currently_playing ??
                                  'Currently playing',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isSelected
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_outline,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
