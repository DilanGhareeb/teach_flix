import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/repositories/course_repository.dart';

class CreateCourse implements Usecase<CreateCourseParams, CourseEntity> {
  final CourseRepository repository;

  CreateCourse(this.repository);

  @override
  Future<Either<Failure, CourseEntity>> call({
    required CreateCourseParams params,
  }) async {
    return await repository.createCourse(params.course);
  }
}

class CreateCourseParams extends Equatable {
  final CourseEntity course;

  const CreateCourseParams({required this.course});

  @override
  List<Object> get props => [course];
}
