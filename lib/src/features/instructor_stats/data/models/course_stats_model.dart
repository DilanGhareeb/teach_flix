import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';

class CourseStatsModel extends CourseStatsEntity {
  const CourseStatsModel({
    required super.courseId,
    required super.courseTitle,
    super.imageUrl,
    required super.studentsEnrolled,
    required super.coursePrice,
    required super.totalRevenue,
    required super.averageRating,
    required super.totalRatings,
    required super.createdAt,
  });

  factory CourseStatsModel.fromEntity(CourseStatsEntity entity) {
    return CourseStatsModel(
      courseId: entity.courseId,
      courseTitle: entity.courseTitle,
      imageUrl: entity.imageUrl,
      studentsEnrolled: entity.studentsEnrolled,
      coursePrice: entity.coursePrice,
      totalRevenue: entity.totalRevenue,
      averageRating: entity.averageRating,
      totalRatings: entity.totalRatings,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'imageUrl': imageUrl,
      'studentsEnrolled': studentsEnrolled,
      'coursePrice': coursePrice,
      'totalRevenue': totalRevenue,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  CourseStatsModel copyWith({
    String? courseId,
    String? courseTitle,
    String? imageUrl,
    int? studentsEnrolled,
    double? coursePrice,
    double? totalRevenue,
    double? averageRating,
    int? totalRatings,
    DateTime? createdAt,
  }) {
    return CourseStatsModel(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      imageUrl: imageUrl ?? this.imageUrl,
      studentsEnrolled: studentsEnrolled ?? this.studentsEnrolled,
      coursePrice: coursePrice ?? this.coursePrice,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
