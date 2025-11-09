import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/usecases/get_quiz_by_id_usecase.dart';
import 'package:teach_flix/src/features/quiz/domain/usecases/get_quiz_result_usecase.dart';
import 'package:teach_flix/src/features/quiz/domain/usecases/submit_quiz_result_usecase.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_event.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuizByIdUseCase getQuizByIdUseCase;
  final SubmitQuizResultUseCase submitQuizResultUseCase;
  final GetQuizResultUseCase getQuizResultUseCase;

  Timer? _timer;
  String? _currentUserId;
  String? _currentCourseId;

  QuizBloc({
    required this.getQuizByIdUseCase,
    required this.submitQuizResultUseCase,
    required this.getQuizResultUseCase,
  }) : super(const QuizState()) {
    on<LoadQuizEvent>(_onLoadQuiz);
    on<StartQuizEvent>(_onStartQuiz);
    on<SelectAnswerEvent>(_onSelectAnswer);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PreviousQuestionEvent>(_onPreviousQuestion);
    on<SubmitQuizEvent>(_onSubmitQuiz);
    on<ReviewQuizEvent>(_onReviewQuiz);
    on<_UpdateTimerEvent>(_onUpdateTimer); // ✅ REGISTER THE HANDLER
  }

  Future<void> _onLoadQuiz(LoadQuizEvent event, Emitter<QuizState> emit) async {
    emit(state.copyWith(status: QuizStatus.loading));

    // Store userId and courseId for auto-submit
    _currentUserId = event.userId;
    _currentCourseId = event.courseId;

    final quizResult = await getQuizByIdUseCase(event.quizId);

    await quizResult.fold(
      (failure) async {
        emit(
          state.copyWith(status: QuizStatus.error, errorMessage: failure.code),
        );
      },
      (quiz) async {
        // Check if user has already completed this quiz
        final previousResultEither = await getQuizResultUseCase(
          userId: event.userId,
          quizId: event.quizId,
        );

        previousResultEither.fold(
          (failure) {
            emit(state.copyWith(status: QuizStatus.ready, quiz: quiz));
          },
          (previousResult) {
            emit(
              state.copyWith(
                status: QuizStatus.ready,
                quiz: quiz,
                previousResult: previousResult,
              ),
            );
          },
        );
      },
    );
  }

  void _onStartQuiz(StartQuizEvent event, Emitter<QuizState> emit) {
    if (state.quiz == null) return;

    final startTime = DateTime.now();
    emit(
      state.copyWith(
        status: QuizStatus.inProgress,
        startTime: startTime,
        remainingTime: state.quiz!.timeLimit,
        currentQuestionIndex: 0,
        selectedAnswers: {},
      ),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime != null && state.remainingTime!.inSeconds > 0) {
        add(const _UpdateTimerEvent());
      } else {
        timer.cancel();
        // Auto-submit when time runs out
        if (state.status == QuizStatus.inProgress &&
            _currentUserId != null &&
            _currentCourseId != null) {
          add(
            SubmitQuizEvent(
              userId: _currentUserId!,
              courseId: _currentCourseId!,
            ),
          );
        }
      }
    });
  }

  void _onUpdateTimer(_UpdateTimerEvent event, Emitter<QuizState> emit) {
    if (state.remainingTime != null && state.remainingTime!.inSeconds > 0) {
      emit(
        state.copyWith(
          remainingTime: Duration(seconds: state.remainingTime!.inSeconds - 1),
        ),
      );
    }
  }

  void _onSelectAnswer(SelectAnswerEvent event, Emitter<QuizState> emit) {
    final updatedAnswers = Map<int, int>.from(state.selectedAnswers);
    updatedAnswers[event.questionIndex] = event.answerIndex;

    emit(state.copyWith(selectedAnswers: updatedAnswers));
  }

  void _onNextQuestion(NextQuestionEvent event, Emitter<QuizState> emit) {
    if (state.canGoNext) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1),
      );
    }
  }

  void _onPreviousQuestion(
    PreviousQuestionEvent event,
    Emitter<QuizState> emit,
  ) {
    if (state.canGoPrevious) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1),
      );
    }
  }

  Future<void> _onSubmitQuiz(
    SubmitQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    if (state.quiz == null || state.startTime == null) return;

    emit(state.copyWith(status: QuizStatus.submitting));
    _timer?.cancel();

    // Calculate score
    int score = 0;
    final answers = <String, int>{};

    for (int i = 0; i < state.quiz!.questions.length; i++) {
      final question = state.quiz!.questions[i];
      final selectedAnswer = state.selectedAnswers[i];

      if (selectedAnswer != null) {
        answers[question.id] = selectedAnswer;
        if (selectedAnswer == question.correctAnswerIndex) {
          score++;
        }
      }
    }

    final timeTaken = DateTime.now().difference(state.startTime!);
    final passed = score >= state.quiz!.passingScore;

    final result = QuizResultEntity(
      id: '',
      userId: event.userId,
      quizId: state.quiz!.id,
      courseId: event.courseId,
      score: score,
      totalQuestions: state.quiz!.questions.length,
      passed: passed,
      completedAt: DateTime.now(),
      timeTaken: timeTaken,
      answers: answers,
    );

    final submitResult = await submitQuizResultUseCase(result);

    submitResult.fold(
      (failure) {
        emit(
          state.copyWith(status: QuizStatus.error, errorMessage: failure.code),
        );
      },
      (savedResult) {
        emit(state.copyWith(status: QuizStatus.completed, result: savedResult));
      },
    );
  }

  void _onReviewQuiz(ReviewQuizEvent event, Emitter<QuizState> emit) {
    emit(state.copyWith(status: QuizStatus.reviewing, currentQuestionIndex: 0));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// Private event for timer updates
class _UpdateTimerEvent extends QuizEvent {
  const _UpdateTimerEvent();
}
