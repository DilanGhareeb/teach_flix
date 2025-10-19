import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class AddRating {
  final CourseRepository repository;

  AddRating(this.repository);

  Future<Either<Failure, void>> call({required AddRatingParams params}) async {
    return await repository.addRating(
      userId: params.userId,
      courseId: params.courseId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class AddRatingParams extends Equatable {
  final String userId;
  final String courseId;
  final double rating;
  final String comment;

  const AddRatingParams({
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [userId, courseId, rating, comment];
}
