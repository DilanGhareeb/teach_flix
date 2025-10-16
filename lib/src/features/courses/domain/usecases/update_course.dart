import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class UpdateCourse {
  final CourseRepository repository;

  UpdateCourse(this.repository);

  Future<Either<Failure, CourseEntity>> call(UpdateCourseParams params) async {
    return await repository.updateCourse(params.course);
  }
}

class UpdateCourseParams extends Equatable {
  final CourseEntity course;

  const UpdateCourseParams({required this.course});

  @override
  List<Object?> get props => [course];
}
