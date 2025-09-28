import 'package:equatable/equatable.dart';

class CourseRatingEntity extends Equatable {
  final double rating;
  final int ratingCount;
  final double averageRating;
  final String ratingDescription;

  const CourseRatingEntity(
    this.rating,
    this.ratingCount,
    this.averageRating,
    this.ratingDescription,
  );

  @override
  List<Object?> get props => [
    rating,
    ratingCount,
    averageRating,
    ratingDescription,
  ];
}
