import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class GetCourseById implements Usecase<GetCourseByIdParams, CourseEntity> {
  final CourseRepository repository;

  GetCourseById(this.repository);

  @override
  Future<Either<Failure, CourseEntity>> call({
    required GetCourseByIdParams params,
  }) async {
    return await repository.getCourseById(params.id);
  }
}

class GetCourseByIdParams extends Equatable {
  final String id;

  const GetCourseByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
