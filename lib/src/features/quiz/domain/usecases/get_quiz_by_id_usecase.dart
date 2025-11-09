import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/repository/quiz_repository.dart';

class GetQuizByIdUseCase {
  final QuizRepository repository;

  GetQuizByIdUseCase({required this.repository});

  Future<Either<Failure, QuizEntity>> call(String quizId) {
    return repository.getQuizById(quizId);
  }
}
