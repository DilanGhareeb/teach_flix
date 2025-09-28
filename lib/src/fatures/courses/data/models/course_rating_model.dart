import 'package:teach_flix/src/fatures/courses/domain/entities/course_rating_entity.dart';

class CourseRatingModel extends CourseRatingEntity {
  const CourseRatingModel(
    super.rating,
    super.ratingCount,
    super.averageRating,
    super.ratingDescription,
  );

  factory CourseRatingModel.fromMap(Map<String, dynamic> map) {
    return CourseRatingModel(
      (map['rating'] ?? 0.0).toDouble(),
      map['ratingCount'] ?? 0,
      (map['averageRating'] ?? 0.0).toDouble(),
      map['ratingDescription'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'ratingCount': ratingCount,
      'averageRating': averageRating,
      'ratingDescription': ratingDescription,
    };
  }
}
