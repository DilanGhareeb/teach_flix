import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class DeleteCourse {
  final CourseRepository repository;

  DeleteCourse(this.repository);

  Future<Either<Failure, void>> call(DeleteCourseParams params) async {
    return await repository.deleteCourse(params.courseId);
  }
}

class DeleteCourseParams extends Equatable {
  final String courseId;

  const DeleteCourseParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}
