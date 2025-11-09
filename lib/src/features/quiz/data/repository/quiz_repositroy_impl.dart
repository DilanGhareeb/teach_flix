import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/quiz/data/datasource/quiz_firebase_datasource.dart';
import 'package:teach_flix/src/features/quiz/data/models/quiz_result_model.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/repository/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizFirebaseDataSource dataSource;

  QuizRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, QuizEntity>> getQuizById(String quizId) {
    return dataSource.getQuizById(quizId);
  }

  @override
  Future<Either<Failure, QuizResultEntity>> submitQuizResult(
    QuizResultEntity result,
  ) {
    return dataSource.submitQuizResult(QuizResultModel.fromEntity(result));
  }

  @override
  Future<Either<Failure, QuizResultEntity?>> getQuizResult({
    required String userId,
    required String quizId,
  }) {
    return dataSource.getQuizResult(userId: userId, quizId: quizId);
  }

  @override
  Future<Either<Failure, List<QuizResultEntity>>> getUserQuizResults({
    required String userId,
    required String courseId,
  }) {
    return dataSource.getUserQuizResults(userId: userId, courseId: courseId);
  }
}
