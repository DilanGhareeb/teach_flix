import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/student_progress_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class GetProgress {
  final CourseRepository repository;

  GetProgress(this.repository);

  Future<Either<Failure, StudentProgressEntity>> call({
    required String userId,
    required String courseId,
  }) {
    return repository.getProgress(userId: userId, courseId: courseId);
  }
}
