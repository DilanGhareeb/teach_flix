import 'package:equatable/equatable.dart';

class CourseStatsEntity extends Equatable {
  final String courseId;
  final String courseTitle;
  final String? imageUrl;
  final int studentsEnrolled;
  final double coursePrice;
  final double totalRevenue;
  final double averageRating;
  final int totalRatings;
  final DateTime createdAt;

  const CourseStatsEntity({
    required this.courseId,
    required this.courseTitle,
    this.imageUrl,
    required this.studentsEnrolled,
    required this.coursePrice,
    required this.totalRevenue,
    required this.averageRating,
    required this.totalRatings,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    courseId,
    courseTitle,
    imageUrl,
    studentsEnrolled,
    coursePrice,
    totalRevenue,
    averageRating,
    totalRatings,
    createdAt,
  ];
}
