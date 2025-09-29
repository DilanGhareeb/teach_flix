import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/course_preview_card.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(LoadCourseDetailEvent(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.course_details), elevation: 0),
      body: BlocListener<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state.status == CoursesStatus.coursePurchased) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.course_purchased_successfully),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == CoursesStatus.failure &&
              state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ErrorLocalizer.of(state.failure!, t)),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            if (state.status == CoursesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == CoursesStatus.courseDetailLoaded &&
                state.selectedCourse != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CoursePreviewCard(
                      course: state.selectedCourse!,
                      onEnroll: () =>
                          _purchaseCourse(context, state.selectedCourse!.id),
                      onPreview: () => _previewCourse(
                        context,
                        state.selectedCourse!.previewVideoUrl,
                      ),
                    ),
                    _buildCourseContent(context, state.selectedCourse!, t),
                  ],
                ),
              );
            } else if (state.status == CoursesStatus.failure &&
                state.failure != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(ErrorLocalizer.of(state.failure!, t)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CoursesBloc>().add(
                          LoadCourseDetailEvent(widget.courseId),
                        );
                      },
                      child: Text(t.retry),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCourseContent(BuildContext context, course, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.course_content,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (course.chapters.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: course.chapters.length,
              itemBuilder: (context, index) {
                final chapter = course.chapters[index];
                return ExpansionTile(
                  title: Text(
                    chapter.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  children: [
                    ...chapter.videosUrls.map(
                      (video) => ListTile(
                        leading: const Icon(Icons.play_circle_outline),
                        title: Text(video.title),
                        subtitle: Text('Video'),
                        onTap: () {
                          // Navigate to video player
                        },
                      ),
                    ),
                    ...chapter.quizzes.map(
                      (quiz) => ListTile(
                        leading: const Icon(Icons.quiz_outlined),
                        title: Text(quiz.title),
                        subtitle: Text('${quiz.questions.length} questions'),
                        onTap: () {
                          // Navigate to quiz
                        },
                      ),
                    ),
                  ],
                );
              },
            )
          else
            Center(
              child: Text(
                t.no_content_available,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
            ),
        ],
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

  void _previewCourse(BuildContext context, String previewUrl) {
    // Implement video preview functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.preview_video),
        content: Text(
          AppLocalizations.of(context)!.preview_functionality_coming_soon,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }
}
