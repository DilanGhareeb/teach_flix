import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/transaction_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/repositories/instructor_stats_repository.dart';

class GetInstructorTransactions {
  final InstructorStatsRepository repository;

  GetInstructorTransactions(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call(
    String instructorId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return repository.getInstructorTransactions(
      instructorId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }
}
