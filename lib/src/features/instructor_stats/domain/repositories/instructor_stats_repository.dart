import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/instructor_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/transaction_entity.dart';

abstract class InstructorStatsRepository {
  Future<Either<Failure, InstructorStatsEntity>> getInstructorStats(
    String instructorId,
  );

  Future<Either<Failure, CourseStatsEntity>> getCourseStats(String courseId);

  Future<Either<Failure, List<TransactionEntity>>> getInstructorTransactions(
    String instructorId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  Future<Either<Failure, List<TransactionEntity>>> getCourseTransactions(
    String courseId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  Stream<Either<Failure, InstructorStatsEntity>> watchInstructorStats(
    String instructorId,
  );
}
