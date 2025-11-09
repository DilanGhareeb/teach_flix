import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';

abstract class QuizRepository {
  Future<Either<Failure, QuizEntity>> getQuizById(String quizId);

  Future<Either<Failure, QuizResultEntity>> submitQuizResult(
    QuizResultEntity result,
  );

  Future<Either<Failure, QuizResultEntity?>> getQuizResult({
    required String userId,
    required String quizId,
  });

  Future<Either<Failure, List<QuizResultEntity>>> getUserQuizResults({
    required String userId,
    required String courseId,
  });
}
