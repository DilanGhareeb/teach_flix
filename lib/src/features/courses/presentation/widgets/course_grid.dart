import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/course_card.dart';

class CourseGrid extends StatelessWidget {
  final List<CourseEntity> courses;
  final Function(CourseEntity)? onCourseTap;

  const CourseGrid({super.key, required this.courses, this.onCourseTap});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid based on screen width
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
          childAspectRatio = 0.75;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2;
          childAspectRatio = 0.72;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
          childAspectRatio = 0.70;
        } else {
          crossAxisCount = 1;
          childAspectRatio = 0.85;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              course: course,
              onTap: () => onCourseTap?.call(course),
              getInstructorName: (instructorId) =>
                  authBloc.getInstructorName(instructorId),
            );
          },
        );
      },
    );
  }
}
