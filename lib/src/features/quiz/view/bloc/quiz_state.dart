import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';

enum QuizStatus {
  initial,
  loading,
  ready,
  inProgress,
  submitting,
  completed,
  reviewing,
  error,
}

class QuizState extends Equatable {
  final QuizStatus status;
  final QuizEntity? quiz;
  final QuizResultEntity? result;
  final QuizResultEntity? previousResult;
  final int currentQuestionIndex;
  final Map<int, int> selectedAnswers;
  final DateTime? startTime;
  final Duration? remainingTime;
  final String? errorMessage;

  const QuizState({
    this.status = QuizStatus.initial,
    this.quiz,
    this.result,
    this.previousResult,
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.startTime,
    this.remainingTime,
    this.errorMessage,
  });

  int get answeredQuestionsCount => selectedAnswers.length;

  bool get isQuestionAnswered =>
      selectedAnswers.containsKey(currentQuestionIndex);

  int? get currentAnswer => selectedAnswers[currentQuestionIndex];

  bool get canGoNext =>
      quiz != null && currentQuestionIndex < quiz!.questions.length - 1;

  bool get canGoPrevious => currentQuestionIndex > 0;

  bool get isLastQuestion =>
      quiz != null && currentQuestionIndex == quiz!.questions.length - 1;

  bool get allQuestionsAnswered =>
      quiz != null && selectedAnswers.length == quiz!.questions.length;

  QuizState copyWith({
    QuizStatus? status,
    QuizEntity? quiz,
    QuizResultEntity? result,
    QuizResultEntity? previousResult,
    int? currentQuestionIndex,
    Map<int, int>? selectedAnswers,
    DateTime? startTime,
    Duration? remainingTime,
    String? errorMessage,
  }) {
    return QuizState(
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
      result: result ?? this.result,
      previousResult: previousResult ?? this.previousResult,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      startTime: startTime ?? this.startTime,
      remainingTime: remainingTime ?? this.remainingTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    quiz,
    result,
    previousResult,
    currentQuestionIndex,
    selectedAnswers,
    startTime,
    remainingTime,
    errorMessage,
  ];
}
