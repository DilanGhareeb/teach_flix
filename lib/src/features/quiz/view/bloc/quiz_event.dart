import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizEvent extends QuizEvent {
  final String quizId;
  final String userId;
  final String courseId;

  const LoadQuizEvent({
    required this.quizId,
    required this.userId,
    required this.courseId,
  });

  @override
  List<Object?> get props => [quizId, userId, courseId];
}

class StartQuizEvent extends QuizEvent {
  const StartQuizEvent();
}

class SelectAnswerEvent extends QuizEvent {
  final int questionIndex;
  final int answerIndex;

  const SelectAnswerEvent({
    required this.questionIndex,
    required this.answerIndex,
  });

  @override
  List<Object?> get props => [questionIndex, answerIndex];
}

class NextQuestionEvent extends QuizEvent {
  const NextQuestionEvent();
}

class PreviousQuestionEvent extends QuizEvent {
  const PreviousQuestionEvent();
}

class SubmitQuizEvent extends QuizEvent {
  final String userId;
  final String courseId;

  const SubmitQuizEvent({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}

class ReviewQuizEvent extends QuizEvent {
  const ReviewQuizEvent();
}
