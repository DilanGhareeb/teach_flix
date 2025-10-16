import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';

class InstructorStatsEntity extends Equatable {
  final String instructorId;
  final int totalCourses;
  final int totalStudents;
  final double todayProfit;
  final double monthProfit;
  final double yearProfit;
  final double totalProfit;
  final List<CourseStatsEntity> courseStats;
  final DateTime lastUpdated;

  const InstructorStatsEntity({
    required this.instructorId,
    required this.totalCourses,
    required this.totalStudents,
    required this.todayProfit,
    required this.monthProfit,
    required this.yearProfit,
    required this.totalProfit,
    required this.courseStats,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    instructorId,
    totalCourses,
    totalStudents,
    todayProfit,
    monthProfit,
    yearProfit,
    totalProfit,
    courseStats,
    lastUpdated,
  ];
}
