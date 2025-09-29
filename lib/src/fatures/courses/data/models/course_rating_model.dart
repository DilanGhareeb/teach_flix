import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_rating_entity.dart';

class CourseRatingModel extends CourseRatingEntity {
  const CourseRatingModel({
    required super.id,
    required super.userId,
    required super.courseId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory CourseRatingModel.fromEntity(CourseRatingEntity entity) {
    return CourseRatingModel(
      id: entity.id,
      userId: entity.userId,
      courseId: entity.courseId,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
    );
  }

  factory CourseRatingModel.fromMap(Map<String, dynamic> map) {
    return CourseRatingModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      courseId: map['courseId'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  factory CourseRatingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseRatingModel(
      id: doc.id,
      userId: data['userId'] as String,
      courseId: data['courseId'] as String,
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }
}
