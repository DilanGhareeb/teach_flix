import 'package:equatable/equatable.dart';

class CourseRatingEntity extends Equatable {
  final String id;
  final String userId;
  final String courseId;
  final double rating; // 1.0 to 5.0
  final String comment;
  final DateTime createdAt;

  const CourseRatingEntity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, courseId, rating, comment, createdAt];
}
