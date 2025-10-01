import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CourseLearningPage extends StatefulWidget {
  final CourseEntity course;

  const CourseLearningPage({super.key, required this.course});

  @override
  State<CourseLearningPage> createState() => _CourseLearningPageState();
}

class _CourseLearningPageState extends State<CourseLearningPage> {
  VideoEntity? _selectedVideo;
  YoutubePlayerController? _youtubeController;
  bool _isPlayerReady = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    if (widget.course.chapters.isNotEmpty &&
        widget.course.chapters[0].videosUrls.isNotEmpty) {
      _selectedVideo = widget.course.chapters[0].videosUrls[0];
      _initializePlayer(_selectedVideo!.youtubeUrl);
    }
  }

  void _initializePlayer(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      // Dispose the old controller if it exists
      if (_youtubeController != null) {
        _youtubeController!.dispose();
      }

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          showLiveFullscreenButton: true,
          useHybridComposition: true,
          forceHD: false, // Allow quality selection
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
        // Load new video in existing controller
        _youtubeController!.load(videoId);
      } else {
        // Initialize new controller if needed
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // If there's no controller, show the UI without YoutubePlayerBuilder
    if (_youtubeController == null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(title: Text(widget.course.title), centerTitle: true),
        body: _buildCourseContent(context, t, colorScheme, null),
      );
    }

    // If there's a controller, use YoutubePlayerBuilder
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
          // Auto-play next video if available
          _playNextVideo();
        },
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          PlaybackSpeedButton(), // Speed control
          FullScreenButton(), // Fullscreen button
        ],
        topActions: [
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _selectedVideo?.title ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Quality settings button (if available in video)
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white, size: 25.0),
            onSelected: (String value) {
              // Handle quality selection
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Quality: $value')));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Auto', child: Text('Auto')),
              const PopupMenuItem(value: '1080p', child: Text('1080p')),
              const PopupMenuItem(value: '720p', child: Text('720p')),
              const PopupMenuItem(value: '480p', child: Text('480p')),
              const PopupMenuItem(value: '360p', child: Text('360p')),
            ],
          ),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: _isFullScreen
              ? null
              : AppBar(title: Text(widget.course.title), centerTitle: true),
          body: _buildCourseContent(context, t, colorScheme, player),
        );
      },
    );
  }

  void _playNextVideo() {
    if (_selectedVideo == null) return;

    // Find current video index
    for (int i = 0; i < widget.course.chapters.length; i++) {
      final chapter = widget.course.chapters[i];
      for (int j = 0; j < chapter.videosUrls.length; j++) {
        if (chapter.videosUrls[j].id == _selectedVideo!.id) {
          // Check if there's a next video in the same chapter
          if (j + 1 < chapter.videosUrls.length) {
            _changeVideo(chapter.videosUrls[j + 1]);
            return;
          }
          // Check if there's a next chapter with videos
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player
          if (player != null) Container(color: Colors.black, child: player),

          // Currently Playing Indicator
          if (_selectedVideo != null && !_isFullScreen)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: colorScheme.primaryContainer.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Now Playing: ${_selectedVideo!.title}',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          if (!_isFullScreen) ...[
            // Course Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getTotalVideos(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.menu_book_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.course.chapters.length} ${t.chapters}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tabs
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: colorScheme.primary,
                    tabs: [
                      Tab(text: t.videos),
                      Tab(text: t.quizzes),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: TabBarView(
                      children: [
                        _buildLessonsList(t, colorScheme),
                        _buildQuizzesList(t, colorScheme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonsList(AppLocalizations t, ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.course.chapters.length,
      itemBuilder: (context, chapterIndex) {
        final chapter = widget.course.chapters[chapterIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chapterIndex > 0) const SizedBox(height: 16),
            Text(
              chapter.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...chapter.videosUrls.map((video) {
              final isSelected = _selectedVideo?.id == video.id;
              final isPlaying =
                  isSelected &&
                  _youtubeController != null &&
                  _youtubeController!.value.isPlaying;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: isSelected ? 3 : 1,
                color: isSelected
                    ? colorScheme.primaryContainer.withOpacity(0.3)
                    : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? colorScheme.primary
                        : Colors.blue.shade600,
                    radius: 20,
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    video.title,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  subtitle: isSelected
                      ? Text(
                          'Currently playing',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 12,
                          ),
                        )
                      : null,
                  trailing: Icon(
                    isSelected ? Icons.play_circle_filled : Icons.chevron_right,
                    color: isSelected ? colorScheme.primary : Colors.grey[400],
                  ),
                  onTap: () {
                    _changeVideo(video);
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildQuizzesList(AppLocalizations t, ColorScheme colorScheme) {
    final allQuizzes = widget.course.chapters
        .expand((chapter) => chapter.quizzes)
        .toList();

    if (allQuizzes.isEmpty) {
      return Center(
        child: Text(
          'No quizzes available',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allQuizzes.length,
      itemBuilder: (context, index) {
        final quiz = allQuizzes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.quiz, color: Colors.white),
            ),
            title: Text(
              quiz.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${quiz.questions.length} ${t.questions}'),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.quiz_functionality_coming_soon)),
              );
            },
          ),
        );
      },
    );
  }

  String _getTotalVideos() {
    final totalVideos = widget.course.chapters.fold<int>(
      0,
      (sum, chapter) => sum + chapter.videosUrls.length,
    );
    return '$totalVideos lessons';
  }
}
