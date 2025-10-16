import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/instructor_stats_entity.dart';

class InstructorStatsModel extends InstructorStatsEntity {
  const InstructorStatsModel({
    required super.instructorId,
    required super.totalCourses,
    required super.totalStudents,
    required super.todayProfit,
    required super.monthProfit,
    required super.yearProfit,
    required super.totalProfit,
    required super.courseStats,
    required super.lastUpdated,
  });

  factory InstructorStatsModel.fromEntity(InstructorStatsEntity entity) {
    return InstructorStatsModel(
      instructorId: entity.instructorId,
      totalCourses: entity.totalCourses,
      totalStudents: entity.totalStudents,
      todayProfit: entity.todayProfit,
      monthProfit: entity.monthProfit,
      yearProfit: entity.yearProfit,
      totalProfit: entity.totalProfit,
      courseStats: entity.courseStats,
      lastUpdated: entity.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instructorId': instructorId,
      'totalCourses': totalCourses,
      'totalStudents': totalStudents,
      'todayProfit': todayProfit,
      'monthProfit': monthProfit,
      'yearProfit': yearProfit,
      'totalProfit': totalProfit,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  InstructorStatsModel copyWith({
    String? instructorId,
    int? totalCourses,
    int? totalStudents,
    double? todayProfit,
    double? monthProfit,
    double? yearProfit,
    double? totalProfit,
    List<CourseStatsEntity>? courseStats,
    DateTime? lastUpdated,
  }) {
    return InstructorStatsModel(
      instructorId: instructorId ?? this.instructorId,
      totalCourses: totalCourses ?? this.totalCourses,
      totalStudents: totalStudents ?? this.totalStudents,
      todayProfit: todayProfit ?? this.todayProfit,
      monthProfit: monthProfit ?? this.monthProfit,
      yearProfit: yearProfit ?? this.yearProfit,
      totalProfit: totalProfit ?? this.totalProfit,
      courseStats: courseStats ?? this.courseStats,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
