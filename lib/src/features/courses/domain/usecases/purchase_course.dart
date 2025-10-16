import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class PurchaseCourse {
  final CourseRepository repository;

  PurchaseCourse(this.repository);

  Future<Either<Failure, void>> call({
    required PurchaseCourseParams params,
  }) async {
    return await repository.purchaseCourse(params.userId, params.courseId);
  }
}

class PurchaseCourseParams extends Equatable {
  final String userId;
  final String courseId;

  const PurchaseCourseParams({required this.userId, required this.courseId});

  @override
  List<Object> get props => [userId, courseId];
}
