import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_rating_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class GetUserRating {
  final CourseRepository repository;

  GetUserRating(this.repository);

  Future<Either<Failure, CourseRatingEntity?>> call({
    required GetUserRatingParams params,
  }) async {
    return await repository.getUserRatingForCourse(
      userId: params.userId,
      courseId: params.courseId,
    );
  }
}

class GetUserRatingParams extends Equatable {
  final String userId;
  final String courseId;

  const GetUserRatingParams({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}
