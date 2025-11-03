import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/student_progress_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class WatchProgress {
  final CourseRepository repository;

  WatchProgress(this.repository);

  Stream<Either<Failure, StudentProgressEntity>> call({
    required String userId,
    required String courseId,
  }) {
    return repository.watchProgress(userId: userId, courseId: courseId);
  }
}
