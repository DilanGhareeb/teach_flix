import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/course_learning_page.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/enrolled_course_card.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  @override
  void initState() {
    super.initState();
    _loadEnrolledCourses();
  }

  void _loadEnrolledCourses() {
    final authState = context.read<AuthBloc>().state;
    if (authState.user != null) {
      context.read<CoursesBloc>().add(
        LoadEnrolledCoursesEvent(authState.user!.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            if (state.status == CoursesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CoursesStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      t.failed_to_load_courses,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadEnrolledCourses,
                      icon: const Icon(Icons.refresh),
                      label: Text(t.retry),
                    ),
                  ],
                ),
              );
            }

            final enrolledCourses = state.enrolledCourses ?? [];

            if (enrolledCourses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 80,
                      color: colorScheme.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t.no_courses_enrolled,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t.browse_and_enroll_courses,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.explore_rounded),
                      label: Text(t.browse_courses),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadEnrolledCourses(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.my_learning,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${enrolledCourses.length} ${enrolledCourses.length == 1 ? t.course : t.courses}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final course = enrolledCourses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: EnrolledCourseCard(
                            course: course,
                            onTap: () => _navigateToCourse(context, course.id),
                          ),
                        );
                      }, childCount: enrolledCourses.length),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToCourse(BuildContext context, String courseId) {
    // Get the full course object from state
    final coursesState = context.read<CoursesBloc>().state;
    final enrolledCourses = coursesState.enrolledCourses ?? [];

    // Find the course by ID
    final course = enrolledCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => throw Exception('Course not found'),
    );

    // Navigate directly to learning page with full course object
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CourseLearningPage(course: course),
      ),
    );
  }
}
