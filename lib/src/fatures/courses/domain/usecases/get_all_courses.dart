import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/repositories/course_repository.dart';

class GetAllCourses {
  final CourseRepository repository;

  GetAllCourses(this.repository);

  Future<Either<Failure, List<CourseEntity>>> call() async {
    return await repository.getAllCourses();
  }
}
