import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/repositories/course_repository.dart';

class GetCoursesByCategory
    implements Usecase<GetCoursesByCategoryParams, List<CourseEntity>> {
  final CourseRepository repository;

  GetCoursesByCategory(this.repository);

  @override
  Future<Either<Failure, List<CourseEntity>>> call({
    required GetCoursesByCategoryParams params,
  }) async {
    return await repository.getCoursesByCategory(params.category);
  }
}

class GetCoursesByCategoryParams extends Equatable {
  final String category;

  const GetCoursesByCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
