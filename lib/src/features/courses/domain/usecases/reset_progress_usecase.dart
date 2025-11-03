import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class ResetProgress {
  final CourseRepository repository;

  ResetProgress(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String courseId,
  }) {
    return repository.resetProgress(userId: userId, courseId: courseId);
  }
}
