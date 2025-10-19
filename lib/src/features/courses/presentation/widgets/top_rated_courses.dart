import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/course_card.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class TopRatedCourses extends StatelessWidget {
  final Function(dynamic course) onCourseTap;

  const TopRatedCourses({super.key, required this.onCourseTap});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final authBloc = context.read<AuthBloc>();

    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state.topRatedCourses == null || state.topRatedCourses!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t.top_rated_courses ?? 'Top Rated Courses',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 230, // ✅ Bounded height
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.topRatedCourses!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final course = state.topRatedCourses![index];
                    return CourseCard(
                      course: course,
                      onTap: () => onCourseTap(course),
                      getInstructorName: (id) => authBloc.getInstructorName(id),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
