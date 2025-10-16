import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class GetEnrolledCourses
    implements Usecase<GetEnrolledCoursesParams, List<CourseEntity>> {
  final CourseRepository repository;

  GetEnrolledCourses(this.repository);

  @override
  Future<Either<Failure, List<CourseEntity>>> call({
    required GetEnrolledCoursesParams params,
  }) async {
    return await repository.getEnrolledCourses(params.userId);
  }
}

class GetEnrolledCoursesParams extends Equatable {
  final String userId;

  const GetEnrolledCoursesParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
