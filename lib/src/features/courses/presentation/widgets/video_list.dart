import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/progress_checkbox.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class VideosList extends StatelessWidget {
  final CourseEntity course;
  final VideoEntity? selectedVideo;
  final YoutubePlayerController? youtubeController;
  final Function(VideoEntity) onVideoTap;
  final ColorScheme colorScheme;
  final String? userId; // ADDED
  final int totalItems; // ADDED

  const VideosList({
    super.key,
    required this.course,
    required this.selectedVideo,
    required this.youtubeController,
    required this.onVideoTap,
    required this.colorScheme,
    this.userId, // ADDED
    required this.totalItems, // ADDED
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (course.chapters.isEmpty ||
        course.chapters.every((c) => c.videosUrls.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              t.no_videos_added ?? 'No videos available',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: course.chapters.length,
      itemBuilder: (context, chapterIndex) {
        final chapter = course.chapters[chapterIndex];

        if (chapter.videosUrls.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              childrenPadding: const EdgeInsets.only(bottom: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.folder_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              title: Text(
                chapter.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${chapter.videosUrls.length} ${chapter.videosUrls.length == 1 ? t.video : t.videos}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              children: chapter.videosUrls.map((video) {
                final isSelected = selectedVideo?.id == video.id;
                final isPlaying = youtubeController?.value.isPlaying ?? false;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer.withOpacity(0.5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: colorScheme.primary.withOpacity(0.5),
                            width: 2,
                          )
                        : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isSelected && isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: isSelected
                                ? Colors.white
                                : colorScheme.primary,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      video.title,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${t.video} ${video.orderIndex + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    // PROGRESS CHECKBOX TRAILING
                    trailing: userId != null
                        ? SizedBox(
                            width: 40,
                            child: ProgressCheckbox(
                              itemId: video.id,
                              itemType: 'video',
                              userId: userId!,
                              courseId: course.id,
                              totalItems: totalItems,
                              showTitle: false,
                            ),
                          )
                        : null,
                    onTap: () => onVideoTap(video),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
