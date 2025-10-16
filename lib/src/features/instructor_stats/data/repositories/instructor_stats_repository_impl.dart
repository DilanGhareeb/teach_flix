import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/instructor_stats/data/datasources/instructor_stats_firebase_datasource.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/instructor_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/transaction_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/repositories/instructor_stats_repository.dart';

class InstructorStatsRepositoryImpl implements InstructorStatsRepository {
  final InstructorStatsFirebaseDataSource _dataSource;

  InstructorStatsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, InstructorStatsEntity>> getInstructorStats(
    String instructorId,
  ) async {
    return await _dataSource.getInstructorStats(instructorId);
  }

  @override
  Future<Either<Failure, CourseStatsEntity>> getCourseStats(
    String courseId,
  ) async {
    return await _dataSource.getCourseStats(courseId);
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getInstructorTransactions(
    String instructorId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    return await _dataSource.getInstructorTransactions(
      instructorId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getCourseTransactions(
    String courseId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _dataSource.getCourseTransactions(
      courseId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Stream<Either<Failure, InstructorStatsEntity>> watchInstructorStats(
    String instructorId,
  ) {
    return _dataSource.watchInstructorStats(instructorId);
  }
}
