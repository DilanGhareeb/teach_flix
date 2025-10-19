import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class GetTopRatedCourses {
  final CourseRepository repository;

  GetTopRatedCourses(this.repository);

  Future<Either<Failure, List<CourseEntity>>> call({int limit = 3}) async {
    return await repository.getTopRatedCourses(limit: limit);
  }
}
