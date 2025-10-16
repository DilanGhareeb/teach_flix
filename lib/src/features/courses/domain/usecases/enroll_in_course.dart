import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class EnrollInCourse {
  final CourseRepository repository;

  EnrollInCourse(this.repository);

  Future<Either<Failure, void>> call({
    required EnrollInCourseParams params,
  }) async {
    return await repository.enrollInCourse(params.userId, params.courseId);
  }
}

class EnrollInCourseParams extends Equatable {
  final String userId;
  final String courseId;

  const EnrollInCourseParams({required this.userId, required this.courseId});

  @override
  List<Object> get props => [userId, courseId];
}
