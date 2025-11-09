import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';

class QuizResultModel extends QuizResultEntity {
  const QuizResultModel({
    required super.id,
    required super.userId,
    required super.quizId,
    required super.courseId,
    required super.score,
    required super.totalQuestions,
    required super.passed,
    required super.completedAt,
    required super.timeTaken,
    required super.answers,
  });

  factory QuizResultModel.fromEntity(QuizResultEntity entity) {
    return QuizResultModel(
      id: entity.id,
      userId: entity.userId,
      quizId: entity.quizId,
      courseId: entity.courseId,
      score: entity.score,
      totalQuestions: entity.totalQuestions,
      passed: entity.passed,
      completedAt: entity.completedAt,
      timeTaken: entity.timeTaken,
      answers: entity.answers,
    );
  }

  factory QuizResultModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return QuizResultModel(
      id: doc.id,
      userId: data['userId'] as String,
      quizId: data['quizId'] as String,
      courseId: data['courseId'] as String,
      score: data['score'] as int,
      totalQuestions: data['totalQuestions'] as int,
      passed: data['passed'] as bool,
      completedAt: (data['completedAt'] as Timestamp).toDate(),
      timeTaken: Duration(seconds: data['timeTakenSeconds'] as int),
      answers: Map<String, int>.from(data['answers'] as Map),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'quizId': quizId,
      'courseId': courseId,
      'score': score,
      'totalQuestions': totalQuestions,
      'passed': passed,
      'completedAt': Timestamp.fromDate(completedAt),
      'timeTakenSeconds': timeTaken.inSeconds,
      'answers': answers,
    };
  }
}
