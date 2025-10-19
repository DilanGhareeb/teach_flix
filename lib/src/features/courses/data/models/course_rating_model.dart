import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_rating_entity.dart';

class CourseRatingModel extends CourseRatingEntity {
  const CourseRatingModel({
    required super.id,
    required super.userId,
    required super.courseId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  // From Firestore DocumentSnapshot
  factory CourseRatingModel.fromFirestore(dynamic source) {
    if (source is DocumentSnapshot) {
      final data = source.data() as Map<String, dynamic>;
      return CourseRatingModel(
        id: source.id,
        userId: data['userId'] as String,
        courseId: data['courseId'] as String,
        rating: (data['rating'] as num).toDouble(),
        comment: data['comment'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } else if (source is Map<String, dynamic>) {
      return CourseRatingModel.fromMap(source);
    } else {
      throw ArgumentError(
        'Invalid source type for CourseRatingModel.fromFirestore',
      );
    }
  }

  // From Map (for nested data in course document)
  factory CourseRatingModel.fromMap(Map<String, dynamic> map) {
    return CourseRatingModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      courseId: map['courseId'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // From Entity
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

  // To Firestore (for standalone rating document)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // To Map (for nested data in course document)
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

  // To Entity
  CourseRatingEntity toEntity() {
    return CourseRatingEntity(
      id: id,
      userId: userId,
      courseId: courseId,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
    );
  }

  // CopyWith
  CourseRatingModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return CourseRatingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
