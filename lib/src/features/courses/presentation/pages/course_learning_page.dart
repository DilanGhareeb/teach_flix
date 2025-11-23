import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/pages/chat_page.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_event.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_state.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/course_info_section.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/course_rating_dialog.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/now_playing_banner.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/progress_indicator_widget.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/quizzes_list.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/video_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CourseLearningPage extends StatefulWidget {
  final CourseEntity course;

  const CourseLearningPage({super.key, required this.course});

  @override
  State<CourseLearningPage> createState() => _CourseLearningPageState();
}

class _CourseLearningPageState extends State<CourseLearningPage>
    with SingleTickerProviderStateMixin {
  VideoEntity? _selectedVideo;
  YoutubePlayerController? _youtubeController;
  bool _isPlayerReady = false;
  bool _isFullScreen = false;
  final bool _autoPlayNext = true;
  late TabController _tabController;

  // NEW: Track which videos have been marked as completed in this session
  final Set<String> _completedVideosInSession = {};

  // NEW: Track if we're in the middle of changing videos
  bool _isChangingVideo = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize video player
    if (widget.course.chapters.isNotEmpty &&
        widget.course.chapters[0].videosUrls.isNotEmpty) {
      _selectedVideo = widget.course.chapters[0].videosUrls[0];
      _initializePlayer(_selectedVideo!.youtubeUrl);
    }

    // LOAD PROGRESS - Get current user and load their progress
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      context.read<ProgressBloc>().add(
        WatchProgressEvent(
          userId: authState.user!.id,
          courseId: widget.course.id,
        ),
      );
    }
  }

  void _initializePlayer(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      if (_youtubeController != null) {
        _youtubeController!.dispose();
      }

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
          showLiveFullscreenButton: true,
          useHybridComposition: true,
          forceHD: false,
        ),
      )..addListener(_listener);

      setState(() {
        _isPlayerReady = false;
      });
    }
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_youtubeController!.value.isFullScreen) {
      setState(() {});

      // Only check for completion if we're not in the middle of changing videos
      if (!_isChangingVideo) {
        _checkAndMarkVideoCompleted();
      }
    }
  }

  // NEW: Method to check if video is completed and mark it automatically
  void _checkAndMarkVideoCompleted() {
    if (_youtubeController == null || _selectedVideo == null) return;

    final authState = context.read<AuthBloc>().state;
    if (authState.user == null) return; // User must be logged in

    // Check if we've already marked this video as completed in this session
    if (_completedVideosInSession.contains(_selectedVideo!.id)) return;

    final playerState = _youtubeController!.value.playerState;
    final position = _youtubeController!.value.position;
    final duration = _youtubeController!.metadata.duration;

    // Check if video has ended or is very close to the end (within last 2 seconds)
    final isNearEnd =
        duration.inSeconds > 0 &&
        (duration.inSeconds - position.inSeconds) <= 2;

    final hasEnded = playerState == PlayerState.ended;

    // Mark as completed if video ended or is near the end
    if (hasEnded || isNearEnd) {
      // Add to session tracking to prevent duplicate marking
      _completedVideosInSession.add(_selectedVideo!.id);

      // Check current progress state to avoid redundant marking
      final progressState = context.read<ProgressBloc>().state;
      bool alreadyCompleted = false;

      if (progressState is ProgressLoaded) {
        alreadyCompleted = progressState.progress.isVideoCompleted(
          _selectedVideo!.id,
        );
      } else if (progressState is ProgressUpdating) {
        alreadyCompleted = progressState.currentProgress.isVideoCompleted(
          _selectedVideo!.id,
        );
      }

      // Only mark as completed if not already completed in the database
      if (!alreadyCompleted) {
        debugPrint('Auto-marking video as completed: ${_selectedVideo!.title}');

        context.read<ProgressBloc>().add(
          ToggleVideoCompletionEvent(
            userId: authState.user!.id,
            courseId: widget.course.id,
            videoId: _selectedVideo!.id,
            isCompleted: true,
            totalItems: _totalItems,
          ),
        );
      }
    }
  }

  void _changeVideo(VideoEntity video) {
    if (_selectedVideo?.id != video.id) {
      // Mark that we're changing videos - this prevents ANY completion checks
      _isChangingVideo = true;

      setState(() {
        _selectedVideo = video;
      });

      final videoId = YoutubePlayer.convertUrlToId(video.youtubeUrl);
      if (videoId != null && _youtubeController != null) {
        _youtubeController!.load(videoId);
      } else {
        _initializePlayer(video.youtubeUrl);
      }

      // Reset the flag after a longer delay to ensure video has fully loaded
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _isChangingVideo = false;
        }
      });
    }
  }

  @override
  void deactivate() {
    _youtubeController?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Calculate total items (videos + quizzes) for progress calculation
  int get _totalItems {
    int count = 0;
    for (var chapter in widget.course.chapters) {
      count += chapter.videosUrls.length;
      count += chapter.quizzes.length;
    }
    return count;
  }

  // AI Assistant Snackbar
  void _showAIAssistantSnackbar(BuildContext context, AppLocalizations t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.smart_toy_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t.ai_assistant_coming_soon ??
                    'AI Assistant feature coming soon!',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show Reset Progress Dialog
  void _showResetProgressDialog(
    BuildContext context,
    AppLocalizations t,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.progress_reset_confirm_title ?? 'Reset Progress?'),
        content: Text(
          t.progress_reset_confirm_message ??
              'Are you sure you want to reset your progress for this course? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(t.cancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<ProgressBloc>().add(
                ResetProgressEvent(userId: userId, courseId: widget.course.id),
              );
              Navigator.of(dialogContext).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.progress_reset_success ?? 'Progress reset successfully',
                  ),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t.reset ?? 'Reset'),
          ),
        ],
      ),
    );
  }

  void _showRateCourseBottomSheet(
    BuildContext context,
    AppLocalizations t,
    ColorScheme colorScheme,
  ) {
    final authState = context.read<AuthBloc>().state;

    // Check if user is logged in
    if (authState.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.please_login_to_rate ?? 'Please log in to rate this course',
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Check if user is the instructor
    if (authState.user!.id == widget.course.instructorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.instructor_cannot_rate_error ??
                'Instructors cannot rate their own courses',
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Get the user's existing rating (if any)
    context
        .read<CoursesBloc>()
        .getUserRating(authState.user!.id, widget.course.id)
        .then((existingRating) {
          // Show the rating dialog
          showDialog(
            context: context,
            builder: (dialogContext) => BlocProvider.value(
              value: context.read<CoursesBloc>(),
              child: CourseRatingDialog(
                courseId: widget.course.id,
                userId: authState.user!.id,
                existingRating: existingRating,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final authState = context.watch<AuthBloc>().state;

    return MultiBlocListener(
      listeners: [
        // Courses Bloc Listener
        BlocListener<CoursesBloc, CoursesState>(
          listener: (context, state) {
            if (state.status == CoursesStatus.ratingAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.rating_added_successfully ?? 'Rating added successfully!',
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }

            if (state.status == CoursesStatus.ratingUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.rating_updated_successfully ??
                        'Rating updated successfully!',
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }

            if (state.status == CoursesStatus.ratingDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.rating_deleted_successfully ??
                        'Rating deleted successfully!',
                  ),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        // PROGRESS BLOC LISTENER
        BlocListener<ProgressBloc, ProgressState>(
          listener: (context, state) {
            if (state is ProgressUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.progress_update_error ?? 'Failed to update progress',
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: _youtubeController == null
          ? Scaffold(
              appBar: AppBar(title: Text(widget.course.title)),
              body: const Center(child: CircularProgressIndicator()),
            )
          : YoutubePlayerBuilder(
              onExitFullScreen: () {
                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                setState(() {
                  _isFullScreen = false;
                });
              },
              onEnterFullScreen: () {
                setState(() {
                  _isFullScreen = true;
                });
              },
              player: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: colorScheme.primary,
                progressColors: ProgressBarColors(
                  playedColor: colorScheme.primary,
                  handleColor: colorScheme.primary,
                  bufferedColor: colorScheme.primary.withOpacity(0.3),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                ),
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) {
                  // CRITICAL: Mark completion ONLY if not already changing videos
                  // and BEFORE triggering the next video
                  if (!_isChangingVideo && _selectedVideo != null) {
                    // Store the current video ID before changing
                    final completedVideoId = _selectedVideo!.id;

                    // Check if already marked in this session
                    if (!_completedVideosInSession.contains(completedVideoId)) {
                      _completedVideosInSession.add(completedVideoId);

                      final authState = context.read<AuthBloc>().state;
                      if (authState.user != null) {
                        // Check if already completed in database
                        final progressState = context
                            .read<ProgressBloc>()
                            .state;
                        bool alreadyCompleted = false;

                        if (progressState is ProgressLoaded) {
                          alreadyCompleted = progressState.progress
                              .isVideoCompleted(completedVideoId);
                        } else if (progressState is ProgressUpdating) {
                          alreadyCompleted = progressState.currentProgress
                              .isVideoCompleted(completedVideoId);
                        }

                        if (!alreadyCompleted) {
                          debugPrint(
                            'Video ended - marking as completed: ${_selectedVideo!.title}',
                          );

                          context.read<ProgressBloc>().add(
                            ToggleVideoCompletionEvent(
                              userId: authState.user!.id,
                              courseId: widget.course.id,
                              videoId: completedVideoId,
                              isCompleted: true,
                              totalItems: _totalItems,
                            ),
                          );
                        }
                      }
                    }
                  }

                  // Now play next video
                  if (_autoPlayNext) {
                    _playNextVideo();
                  }
                },
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 8),
                  ProgressBar(isExpanded: true),
                  const SizedBox(width: 8),
                  RemainingDuration(),
                  PlaybackSpeedButton(),
                  FullScreenButton(),
                ],
                topActions: [
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _selectedVideo?.title ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
              builder: (context, player) {
                return Scaffold(
                  backgroundColor: colorScheme.surface,
                  body: _buildCourseContent(
                    context,
                    t,
                    colorScheme,
                    player,
                    authState.user?.id,
                  ),
                );
              },
            ),
    );
  }

  void _playNextVideo() {
    if (_selectedVideo == null) return;

    for (int i = 0; i < widget.course.chapters.length; i++) {
      final chapter = widget.course.chapters[i];
      for (int j = 0; j < chapter.videosUrls.length; j++) {
        if (chapter.videosUrls[j].id == _selectedVideo!.id) {
          if (j + 1 < chapter.videosUrls.length) {
            _changeVideo(chapter.videosUrls[j + 1]);
            return;
          }
          if (i + 1 < widget.course.chapters.length) {
            final nextChapter = widget.course.chapters[i + 1];
            if (nextChapter.videosUrls.isNotEmpty) {
              _changeVideo(nextChapter.videosUrls[0]);
              return;
            }
          }
        }
      }
    }
  }

  Widget _buildCourseContent(
    BuildContext context,
    AppLocalizations t,
    ColorScheme colorScheme,
    Widget? player,
    String? userId,
  ) {
    return CustomScrollView(
      slivers: [
        if (!_isFullScreen)
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            title: Text(
              widget.course.title,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            actions: [
              // AI Assistant Button
              IconButton(
                icon: const Icon(Icons.smart_toy_outlined),
                tooltip: t.ai_assistant ?? 'AI Assistant',
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AiChatPage(),
                    ),
                  );
                },
              ),
              // Rate Course Button
              IconButton(
                icon: const Icon(Icons.star_outline_rounded),
                tooltip: t.rate_course ?? 'Rate Course',
                onPressed: () =>
                    _showRateCourseBottomSheet(context, t, colorScheme),
              ),
            ],
          ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (player != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: player,
                ),
              if (_selectedVideo != null && !_isFullScreen)
                NowPlayingBanner(
                  videoTitle: _selectedVideo!.title,
                  autoPlayEnabled: _autoPlayNext,
                  colorScheme: colorScheme,
                ),
              if (!_isFullScreen) ...[
                // PROGRESS INDICATOR SECTION
                if (userId != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t.progress_overall ?? 'Your Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ProgressIndicatorWidget(
                          courseId: widget.course.id,
                          showPercentage: true,
                          showItemsCount: false,
                        ),
                      ],
                    ),
                  ),
                CourseInfoSection(
                  course: widget.course,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        if (!_isFullScreen)
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
                indicatorColor: colorScheme.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_outline, size: 18),
                        const SizedBox(width: 6),
                        Text(t.videos),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.quiz_outlined, size: 18),
                        const SizedBox(width: 6),
                        Text(t.quizzes),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!_isFullScreen)
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // PASS userId AND totalItems TO VideosList
                VideosList(
                  course: widget.course,
                  selectedVideo: _selectedVideo,
                  youtubeController: _youtubeController,
                  onVideoTap: _changeVideo,
                  colorScheme: colorScheme,
                  userId: userId,
                  totalItems: _totalItems,
                ),
                // PASS userId AND totalItems TO QuizzesList
                QuizzesList(
                  course: widget.course,
                  colorScheme: colorScheme,
                  userId: userId,
                  totalItems: _totalItems,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Custom Sticky Tab Bar Delegate
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
