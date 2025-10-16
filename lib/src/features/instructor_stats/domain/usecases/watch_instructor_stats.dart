import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/instructor_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/repositories/instructor_stats_repository.dart';

class WatchInstructorStats {
  final InstructorStatsRepository repository;

  WatchInstructorStats(this.repository);

  Stream<Either<Failure, InstructorStatsEntity>> call(String instructorId) {
    return repository.watchInstructorStats(instructorId);
  }
}
