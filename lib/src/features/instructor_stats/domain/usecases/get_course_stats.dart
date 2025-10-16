import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/repositories/instructor_stats_repository.dart';

class GetCourseStats {
  final InstructorStatsRepository repository;

  GetCourseStats(this.repository);

  Future<Either<Failure, CourseStatsEntity>> call(String courseId) {
    return repository.getCourseStats(courseId);
  }
}
