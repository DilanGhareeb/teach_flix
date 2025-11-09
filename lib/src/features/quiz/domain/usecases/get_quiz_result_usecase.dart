import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/repository/quiz_repository.dart';

class GetQuizResultUseCase {
  final QuizRepository repository;

  GetQuizResultUseCase({required this.repository});

  Future<Either<Failure, QuizResultEntity?>> call({
    required String userId,
    required String quizId,
  }) {
    return repository.getQuizResult(userId: userId, quizId: quizId);
  }
}
