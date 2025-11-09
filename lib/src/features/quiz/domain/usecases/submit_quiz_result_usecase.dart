import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/repository/quiz_repository.dart';

class SubmitQuizResultUseCase {
  final QuizRepository repository;

  SubmitQuizResultUseCase({required this.repository});

  Future<Either<Failure, QuizResultEntity>> call(QuizResultEntity result) {
    return repository.submitQuizResult(result);
  }
}
