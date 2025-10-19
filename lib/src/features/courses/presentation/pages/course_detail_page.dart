import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/common/error_localizer.dart';
import 'package:teach_flix/src/features/courses/presentation/pages/all_reviews_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/pages/course_learning_page.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
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
            autoPlay: false,
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
                content: Text(
                  widget.course.price == 0
                      ? (t.enrolled_successfully ?? 'Enrolled successfully!')
                      : (t.course_purchased_successfully ??
                            'Course purchased successfully!'),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            final authState = context.read<AuthBloc>().state;
            if (authState.user != null) {
              context.read<CoursesBloc>().add(
                LoadEnrolledCoursesEvent(authState.user!.id),
              );
            }
          }

          if (state.status == CoursesStatus.failure && state.failure != null) {
            String errorMessage = ErrorLocalizer.of(state.failure!, t);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                action: SnackBarAction(
                  label: t.dismiss ?? 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isOwned = _isOwned(state);
          return _buildCourseDetail(
            context,
            widget.course,
            isOwned,
            state,
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
    CoursesState state,
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
            // App Bar with Course Image
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

            // Course Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Header Section
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
                        const SizedBox(height: 12),

                        // Instructor Section - NEW
                        FutureBuilder<String>(
                          future: context.read<AuthBloc>().getInstructorName(
                            course.instructorId,
                          ),
                          builder: (context, snapshot) {
                            final instructorName = snapshot.hasData
                                ? snapshot.data!
                                : snapshot.hasError
                                ? t.instructor ?? 'Instructor'
                                : '...';

                            return Row(
                              children: [
                                Icon(
                                  Icons.person_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),

                                Text(
                                  instructorName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            );
                          },
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

                  // Trailer Section
                  if (_trailerController != null)
                    _buildTrailerSection(t, colorScheme),

                  // Price Section (only for paid courses that user doesn't own)
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

                  // Free Badge (for free courses that user doesn't own)
                  if (!isOwned && course.price == 0)
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.green.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
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
                              Icons.card_giftcard,
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
                                  t.free_course ?? 'Free Course',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.enroll_free ?? 'Enroll for Free',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Description Section
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

                  // Course Content/Chapters Section
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

                  // Reviews Section
                  if (course.ratings.isNotEmpty)
                    _buildReviewsSection(context, course, t, colorScheme),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),

        // Bottom Action Button
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
                  onPressed: state.status == CoursesStatus.purchasing
                      ? null
                      : (isOwned
                            ? () => _startLearning(context, course)
                            : () => _purchaseCourse(context, course.id, t)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOwned
                        ? Colors.green
                        : colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    disabledBackgroundColor: colorScheme.primary.withOpacity(
                      0.6,
                    ),
                  ),
                  child: state.status == CoursesStatus.purchasing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              t.processing ?? 'Processing...',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isOwned
                                  ? Icons.play_circle_filled
                                  : (course.price == 0
                                        ? Icons.download_rounded
                                        : Icons.shopping_bag),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isOwned
                                  ? (t.start_learning ?? 'Start Learning')
                                  : (course.price == 0
                                        ? (t.enroll_free ?? 'Enroll for Free')
                                        : (t.enroll_now ?? 'Buy Now')),
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

  // Rest of the methods remain the same...
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
    BuildContext context,
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
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Wrap title in Flexible so it can resize
                  Flexible(
                    child: AutoSizeText(
                      t.student_reviews ?? 'Student Reviews',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                      stepGranularity: 0.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (course.ratings.length > 3)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => AllReviewsPage(course: course),
                          ),
                        );
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          t.view_all ?? 'View All',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                ],
              );
            },
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
                              FutureBuilder<String>(
                                future: context.read<AuthBloc>().getUserName(
                                  rating.userId,
                                ),
                                builder: (context, snapshot) {
                                  final userName = snapshot.hasData
                                      ? snapshot.data!
                                      : snapshot.hasError
                                      ? t.student ?? 'Student'
                                      : '...';
                                  return Text(
                                    userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
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

  void _purchaseCourse(
    BuildContext context,
    String courseId,
    AppLocalizations t,
  ) {
    final authState = context.read<AuthBloc>().state;

    if (authState.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.please_login ?? 'Please log in to enroll'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            t.confirm_purchase ?? 'Confirm Purchase',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.course.price == 0
                    ? (t.confirm_enroll_message ??
                          'Are you sure you want to enroll in this course?')
                    : (t.confirm_purchase_message ??
                          'Are you sure you want to purchase this course?'),
              ),
              if (widget.course.price > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(dialogContext).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.payments,
                        color: Theme.of(dialogContext).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.total_amount ?? 'Total Amount',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(dialogContext)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withOpacity(0.7),
                              ),
                            ),
                            Text(
                              formatter.formatIqd(widget.course.price),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  dialogContext,
                                ).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                t.cancel ?? 'Cancel',
                style: TextStyle(
                  color: Theme.of(
                    dialogContext,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                // Proceed with purchase/enrollment
                if (widget.course.price == 0) {
                  context.read<CoursesBloc>().add(
                    EnrollInCourseEvent(
                      userId: authState.user!.id,
                      courseId: courseId,
                    ),
                  );
                } else {
                  context.read<CoursesBloc>().add(
                    PurchaseCourseEvent(
                      userId: authState.user!.id,
                      courseId: courseId,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.course.price == 0
                    ? Colors.green
                    : Theme.of(dialogContext).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.course.price == 0
                    ? (t.confirm_enroll ?? 'Yes, Enroll')
                    : (t.confirm_buy ?? 'Yes, Buy Now'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startLearning(BuildContext context, CourseEntity course) {
    // Stop the video player if it's working
    if (_trailerController != null && _trailerController!.value.isPlaying) {
      _trailerController!.pause();
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CourseLearningPage(course: course),
      ),
    );
  }
}
