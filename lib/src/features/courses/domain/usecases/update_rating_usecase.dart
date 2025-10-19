import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class UpdateRating {
  final CourseRepository repository;

  UpdateRating(this.repository);

  Future<Either<Failure, void>> call({
    required UpdateRatingParams params,
  }) async {
    return await repository.updateRating(
      ratingId: params.ratingId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class UpdateRatingParams extends Equatable {
  final String ratingId;
  final double rating;
  final String comment;

  const UpdateRatingParams({
    required this.ratingId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [ratingId, rating, comment];
}
