import 'package:equatable/equatable.dart';

class QuizResultEntity extends Equatable {
  final String id;
  final String userId;
  final String quizId;
  final String courseId;
  final int score;
  final int totalQuestions;
  final bool passed;
  final DateTime completedAt;
  final Duration timeTaken;
  final Map<String, int> answers;

  const QuizResultEntity({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.courseId,
    required this.score,
    required this.totalQuestions,
    required this.passed,
    required this.completedAt,
    required this.timeTaken,
    required this.answers,
  });

  double get percentage => (score / totalQuestions) * 100;

  @override
  List<Object?> get props => [
    id,
    userId,
    quizId,
    courseId,
    score,
    totalQuestions,
    passed,
    completedAt,
    timeTaken,
    answers,
  ];
}
