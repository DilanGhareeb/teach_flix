import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/course_learning_page.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseEntity course;

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final formatter = Formatter();
  YoutubePlayerController? _trailerController;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      context.read<CoursesBloc>().add(
        LoadEnrolledCoursesEvent(authState.user!.id),
      );
    }

    if (widget.course.previewVideoUrl.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(
        widget.course.previewVideoUrl,
      );
      if (videoId != null) {
        _trailerController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: false,
            showLiveFullscreenButton: true,
            useHybridComposition: true,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _trailerController?.dispose();
    super.dispose();
  }

  bool _isOwned(CoursesState state) {
    final enrolledCourses = state.enrolledCourses ?? [];
    return enrolledCourses.any((course) => course.id == widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state.status == CoursesStatus.coursePurchased) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.course_purchased_successfully),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            final authState = context.read<AuthBloc>().state;
            if (authState.user != null) {
              context.read<CoursesBloc>().add(
                LoadEnrolledCoursesEvent(authState.user!.id),
              );
            }
          }
        },
        builder: (context, state) {
          final isOwned = _isOwned(state);
          return _buildCourseDetail(
            context,
            widget.course,
            isOwned,
            t,
            colorScheme,
          );
        },
      ),
    );
  }

  Widget _buildCourseDetail(
    BuildContext context,
    CourseEntity course,
    bool isOwned,
    AppLocalizations t,
    ColorScheme colorScheme,
  ) {
    final totalVideos = course.chapters.fold<int>(
      0,
      (sum, chapter) => sum + chapter.videosUrls.length,
    );
    final totalQuizzes = course.chapters.fold<int>(
      0,
      (sum, chapter) => sum + chapter.quizzes.length,
    );
    final averageRating = course.ratings.isEmpty
        ? 0.0
        : course.ratings.fold<double>(0, (sum, r) => sum + r.rating) /
              course.ratings.length;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              elevation: 0,
              backgroundColor: colorScheme.surface,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (course.imageUrl.isNotEmpty)
                      Image.network(
                        course.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.secondary,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.school,
                                size: 80,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.school,
                            size: 80,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    if (isOwned)
                      Positioned(
                        top: 80,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                t.owned ?? 'Owned',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primaryContainer.withOpacity(0.3),
                          colorScheme.secondaryContainer.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (course.category.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              course.category,
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          course.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 16),
                        if (course.ratings.isNotEmpty)
                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < averageRating
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: Colors.amber[700],
                                  size: 24,
                                );
                              }),
                              const SizedBox(width: 12),
                              Text(
                                averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${course.ratings.length} ${t.reviews ?? "reviews"})',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildStatCard(
                              Icons.play_circle_outline,
                              '$totalVideos',
                              t.videos,
                              colorScheme,
                              Colors.blue,
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              Icons.menu_book_outlined,
                              '${course.chapters.length}',
                              t.chapters,
                              colorScheme,
                              Colors.green,
                            ),
                            const SizedBox(width: 12),
                            _buildStatCard(
                              Icons.quiz_outlined,
                              '$totalQuizzes',
                              t.quizzes,
                              colorScheme,
                              Colors.purple,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (_trailerController != null)
                    _buildTrailerSection(t, colorScheme),

                  if (!isOwned && course.price > 0)
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_offer,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.special_offer ?? 'Special Offer',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatter.formatIqd(course.price),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (course.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.what_you_will_learn ?? 'What You\'ll Learn',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              course.description,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.8),
                                height: 1.6,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.course_content,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        if (course.chapters.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: course.chapters.length,
                            itemBuilder: (context, index) {
                              final chapter = course.chapters[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ExpansionTile(
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          colorScheme.primary,
                                          colorScheme.primary.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    chapter.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${chapter.videosUrls.length} videos • ${chapter.quizzes.length} quizzes',
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withOpacity(
                                        0.6,
                                      ),
                                      fontSize: 13,
                                    ),
                                  ),
                                  children: [
                                    ...chapter.videosUrls.map((video) {
                                      return ListTile(
                                        leading: Icon(
                                          Icons.play_circle_outline,
                                          color: isOwned
                                              ? Colors.blue
                                              : colorScheme.onSurface
                                                    .withOpacity(0.3),
                                        ),
                                        title: Text(video.title),
                                        trailing: isOwned
                                            ? null
                                            : Icon(
                                                Icons.lock_outline,
                                                size: 20,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.3),
                                              ),
                                      );
                                    }),
                                    ...chapter.quizzes.map((quiz) {
                                      return ListTile(
                                        leading: Icon(
                                          Icons.quiz_outlined,
                                          color: isOwned
                                              ? Colors.purple
                                              : colorScheme.onSurface
                                                    .withOpacity(0.3),
                                        ),
                                        title: Text(quiz.title),
                                        subtitle: Text(
                                          '${quiz.questions.length} ${t.questions}',
                                        ),
                                        trailing: isOwned
                                            ? null
                                            : Icon(
                                                Icons.lock_outline,
                                                size: 20,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.3),
                                              ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                t.no_content_available ??
                                    'No content available',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (course.ratings.isNotEmpty)
                    _buildReviewsSection(course, t, colorScheme),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isOwned
                      ? () => _startLearning(context, course)
                      : () => _purchaseCourse(context, course.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOwned
                        ? Colors.green
                        : colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isOwned ? Icons.play_circle_filled : Icons.shopping_bag,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isOwned
                            ? (t.start_learning ?? 'Start Learning')
                            : (t.enroll_now ?? 'Enroll Now'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailerSection(AppLocalizations t, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.course_trailer ?? 'Course Trailer',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(
                controller: _trailerController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: colorScheme.primary,
                progressColors: ProgressBarColors(
                  playedColor: colorScheme.primary,
                  handleColor: colorScheme.primary,
                  bufferedColor: colorScheme.primary.withOpacity(0.3),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                ),
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 8),
                  ProgressBar(isExpanded: true),
                  const SizedBox(width: 8),
                  RemainingDuration(),
                  PlaybackSpeedButton(),
                  FullScreenButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(
    CourseEntity course,
    AppLocalizations t,
    ColorScheme colorScheme,
  ) {
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
                TextButton(
                  onPressed: () {},
                  child: Text(t.view_all ?? 'View All'),
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
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: colorScheme.primary,
                          child: Text(
                            rating.userId[0].toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rating.userId,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < rating.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16,
                                    color: Colors.amber[700],
                                  );
                                }),
                              ),
                            ],
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
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    ColorScheme colorScheme,
    Color accentColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: accentColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  void _purchaseCourse(BuildContext context, String courseId) {
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      context.read<CoursesBloc>().add(
        PurchaseCourseEvent(userId: authState.user!.id, courseId: courseId),
      );
    }
  }

  void _startLearning(BuildContext context, CourseEntity course) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CourseLearningPage(course: course),
      ),
    );
  }
}
