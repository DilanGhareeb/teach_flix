import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_bloc.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_event.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_state.dart';
import 'package:teach_flix/src/features/quiz/view/pages/quiz_question_screen.dart';
import 'package:teach_flix/src/features/quiz/view/pages/quiz_result_screen.dart';
import 'package:teach_flix/src/features/quiz/view/pages/quiz_review_screen.dart';
import 'package:teach_flix/src/features/quiz/view/pages/quiz_start_screen.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class QuizPage extends StatelessWidget {
  final QuizEntity quiz;
  final String userId;
  final String courseId;

  const QuizPage({
    super.key,
    required this.quiz,
    required this.userId,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state.status == QuizStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? t.quiz_error_occurred),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state.status == QuizStatus.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      t.quiz_loading,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.status == QuizStatus.ready) {
              return QuizStartScreen(
                quiz: state.quiz!,
                previousResult: state.previousResult,
                onStart: () {
                  context.read<QuizBloc>().add(const StartQuizEvent());
                },
              );
            }

            if (state.status == QuizStatus.inProgress ||
                state.status == QuizStatus.submitting) {
              return QuizQuestionScreen(
                quiz: state.quiz!,
                currentQuestionIndex: state.currentQuestionIndex,
                selectedAnswers: state.selectedAnswers,
                remainingTime: state.remainingTime,
                isSubmitting: state.status == QuizStatus.submitting,
                onAnswerSelected: (answerIndex) {
                  context.read<QuizBloc>().add(
                    SelectAnswerEvent(
                      questionIndex: state.currentQuestionIndex,
                      answerIndex: answerIndex,
                    ),
                  );
                },
                onNext: () {
                  context.read<QuizBloc>().add(const NextQuestionEvent());
                },
                onPrevious: () {
                  context.read<QuizBloc>().add(const PreviousQuestionEvent());
                },
                onSubmit: () {
                  _showSubmitConfirmation(context, t, state);
                },
              );
            }

            if (state.status == QuizStatus.completed) {
              return QuizResultScreen(
                result: state.result!,
                quiz: state.quiz!,
                onReview: () {
                  context.read<QuizBloc>().add(const ReviewQuizEvent());
                },
                onRetake: () {
                  context.read<QuizBloc>().add(const StartQuizEvent());
                },
                onClose: () {
                  Navigator.of(context).pop();
                },
              );
            }

            if (state.status == QuizStatus.reviewing) {
              return QuizReviewScreen(
                quiz: state.quiz!,
                result: state.result!,
                currentQuestionIndex: state.currentQuestionIndex,
                onNext: () {
                  context.read<QuizBloc>().add(const NextQuestionEvent());
                },
                onPrevious: () {
                  context.read<QuizBloc>().add(const PreviousQuestionEvent());
                },
                onClose: () {
                  Navigator.of(context).pop();
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showSubmitConfirmation(
    BuildContext context,
    AppLocalizations t,
    QuizState state,
  ) {
    final unansweredCount =
        state.quiz!.questions.length - state.answeredQuestionsCount;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.quiz_submit_confirmation_title),
        content: Text(
          unansweredCount > 0
              ? t.quiz_submit_with_unanswered(unansweredCount)
              : t.quiz_submit_all_answered,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<QuizBloc>().add(
                SubmitQuizEvent(userId: userId, courseId: courseId),
              );
            },
            child: Text(t.quiz_submit),
          ),
        ],
      ),
    );
  }
}
