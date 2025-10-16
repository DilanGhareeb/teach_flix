import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/course_info_section.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/now_playing_banner.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.course.chapters.isNotEmpty &&
        widget.course.chapters[0].videosUrls.isNotEmpty) {
      _selectedVideo = widget.course.chapters[0].videosUrls[0];
      _initializePlayer(_selectedVideo!.youtubeUrl);
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
    }
  }

  void _changeVideo(VideoEntity video) {
    if (_selectedVideo?.id != video.id) {
      setState(() {
        _selectedVideo = video;
      });

      final videoId = YoutubePlayer.convertUrlToId(video.youtubeUrl);
      if (videoId != null && _youtubeController != null) {
        _youtubeController!.load(videoId);
      } else {
        _initializePlayer(video.youtubeUrl);
      }
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (_youtubeController == null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(widget.course.title),
          centerTitle: true,
          elevation: 0,
        ),
        body: _buildCourseContent(context, t, colorScheme, null),
      );
    }

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        _isFullScreen = true;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      onExitFullScreen: () {
        _isFullScreen = false;
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
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
          body: _buildCourseContent(context, t, colorScheme, player),
        );
      },
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
                VideosList(
                  course: widget.course,
                  selectedVideo: _selectedVideo,
                  youtubeController: _youtubeController,
                  onVideoTap: _changeVideo,
                  colorScheme: colorScheme,
                ),
                QuizzesList(course: widget.course, colorScheme: colorScheme),
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
