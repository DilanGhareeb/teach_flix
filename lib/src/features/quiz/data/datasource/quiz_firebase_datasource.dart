import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/quiz/data/models/quiz_model.dart';
import 'package:teach_flix/src/features/quiz/data/models/quiz_result_model.dart';

abstract class QuizFirebaseDataSource {
  Future<Either<Failure, QuizModel>> getQuizById(String quizId);

  Future<Either<Failure, QuizResultModel>> submitQuizResult(
    QuizResultModel result,
  );

  Future<Either<Failure, QuizResultModel?>> getQuizResult({
    required String userId,
    required String quizId,
  });

  Future<Either<Failure, List<QuizResultModel>>> getUserQuizResults({
    required String userId,
    required String courseId,
  });
}

class QuizFirebaseDataSourceImpl implements QuizFirebaseDataSource {
  final FirebaseFirestore _firestore;

  QuizFirebaseDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, QuizModel>> getQuizById(String quizId) async {
    try {
      // Find quiz in any course's chapters
      final coursesSnapshot = await _firestore.collection('courses').get();

      for (final courseDoc in coursesSnapshot.docs) {
        final courseData = courseDoc.data();
        final chapters = courseData['chapters'] as List<dynamic>?;

        if (chapters != null) {
          for (final chapter in chapters) {
            final quizzes = chapter['quizzes'] as List<dynamic>?;
            if (quizzes != null) {
              for (final quizData in quizzes) {
                if (quizData['id'] == quizId) {
                  return Right(
                    QuizModel.fromMap(quizData as Map<String, dynamic>),
                  );
                }
              }
            }
          }
        }
      }

      return const Left(NotFoundFailure());
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, QuizResultModel>> submitQuizResult(
    QuizResultModel result,
  ) async {
    try {
      final docRef = _firestore.collection('quiz_results').doc();
      final resultWithId = QuizResultModel(
        id: docRef.id,
        userId: result.userId,
        quizId: result.quizId,
        courseId: result.courseId,
        score: result.score,
        totalQuestions: result.totalQuestions,
        passed: result.passed,
        completedAt: result.completedAt,
        timeTaken: result.timeTaken,
        answers: result.answers,
      );

      await docRef.set(resultWithId.toFirestore());

      return Right(resultWithId);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, QuizResultModel?>> getQuizResult({
    required String userId,
    required String quizId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('quiz_results')
          .where('userId', isEqualTo: userId)
          .where('quizId', isEqualTo: quizId)
          .orderBy('completedAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Right(null);
      }

      final result = QuizResultModel.fromFirestore(querySnapshot.docs.first);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<QuizResultModel>>> getUserQuizResults({
    required String userId,
    required String courseId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('quiz_results')
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .orderBy('completedAt', descending: true)
          .get();

      final results = querySnapshot.docs
          .map((doc) => QuizResultModel.fromFirestore(doc))
          .toList();

      return Right(results);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
