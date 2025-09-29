import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/course_card.dart';

class HorizontalCourseList extends StatelessWidget {
  final List<CourseEntity> courses;
  final Function(CourseEntity)? onCourseTap;

  const HorizontalCourseList({
    super.key,
    required this.courses,
    this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Fixed height for cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < courses.length - 1 ? 16 : 0,
            ),
            child: CourseCard(
              course: course,
              width: 320,
              onTap: () => onCourseTap?.call(course),
            ),
          );
        },
      ),
    );
  }
}
