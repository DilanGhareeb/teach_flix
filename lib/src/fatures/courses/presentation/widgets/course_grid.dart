import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/course_card.dart';

class CourseGrid extends StatelessWidget {
  final List<CourseEntity> courses;
  final Function(CourseEntity) onCourseTap;
  final bool showPrice;

  const CourseGrid({
    super.key,
    required this.courses,
    required this.onCourseTap,
    this.showPrice = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          course: course,
          onTap: () => onCourseTap(course),
          showPrice: showPrice,
        );
      },
    );
  }
}
