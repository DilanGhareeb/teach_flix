import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/student_progress_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class GetUserAllProgress {
  final CourseRepository repository;

  GetUserAllProgress(this.repository);

  Future<Either<Failure, List<StudentProgressEntity>>> call({
    required String userId,
  }) {
    return repository.getUserAllProgress(userId: userId);
  }
}
