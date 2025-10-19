import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class DeleteRating {
  final CourseRepository repository;

  DeleteRating(this.repository);

  Future<Either<Failure, void>> call({
    required DeleteRatingParams params,
  }) async {
    return await repository.deleteRating(params.ratingId);
  }
}

class DeleteRatingParams extends Equatable {
  final String ratingId;

  const DeleteRatingParams({required this.ratingId});

  @override
  List<Object?> get props => [ratingId];
}
