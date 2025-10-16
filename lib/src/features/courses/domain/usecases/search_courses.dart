import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class SearchCourses
    implements Usecase<SearchCoursesParams, List<CourseEntity>> {
  final CourseRepository repository;

  SearchCourses(this.repository);

  @override
  Future<Either<Failure, List<CourseEntity>>> call({
    required SearchCoursesParams params,
  }) async {
    return await repository.searchCourses(params.query);
  }
}

class SearchCoursesParams extends Equatable {
  final String query;

  const SearchCoursesParams({required this.query});

  @override
  List<Object> get props => [query];
}
