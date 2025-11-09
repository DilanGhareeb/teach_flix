import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class QuizReviewScreen extends StatelessWidget {
  final QuizEntity quiz;
  final QuizResultEntity result;
  final int currentQuestionIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onClose;

  const QuizReviewScreen({
    super.key,
    required this.quiz,
    required this.result,
    required this.currentQuestionIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final currentQuestion = quiz.questions[currentQuestionIndex];
    final userAnswer = result.answers[currentQuestion.id];
    final correctAnswer = currentQuestion.correctAnswerIndex;
    final isCorrect = userAnswer == correctAnswer;
    final canGoNext = currentQuestionIndex < quiz.questions.length - 1;
    final canGoPrevious = currentQuestionIndex > 0;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${currentQuestionIndex + 1}/${quiz.questions.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / quiz.questions.length,
                    minHeight: 8,
                    backgroundColor: colorScheme.primaryContainer.withOpacity(
                      0.3,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Review Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question Text
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      currentQuestion.question,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Answer Options
                  ...List.generate(currentQuestion.options.length, (index) {
                    final isUserAnswer = userAnswer == index;
                    final isCorrectAnswer = correctAnswer == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ReviewAnswerOption(
                        option: currentQuestion.options[index],
                        index: index,
                        isUserAnswer: isUserAnswer,
                        isCorrectAnswer: isCorrectAnswer,
                        colorScheme: colorScheme,
                        t: t,
                      ),
                    );
                  }),

                  // Explanation
                  if (currentQuestion.explanation.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                color: Colors.blue[700],
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                t.quiz_explanation,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentQuestion.explanation,
                            style: TextStyle(
                              fontSize: 15,
                              color: colorScheme.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (canGoPrevious)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPrevious,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: Text(t.quiz_previous),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (canGoPrevious) const SizedBox(width: 12),
                if (canGoNext)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onNext,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(t.quiz_next),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (!canGoNext)
                  Expanded(
                    child: FilledButton(
                      onPressed: onClose,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(t.close),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewAnswerOption extends StatelessWidget {
  final String option;
  final int index;
  final bool isUserAnswer;
  final bool isCorrectAnswer;
  final ColorScheme colorScheme;
  final AppLocalizations t;

  const _ReviewAnswerOption({
    required this.option,
    required this.index,
    required this.isUserAnswer,
    required this.isCorrectAnswer,
    required this.colorScheme,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final optionLabel = String.fromCharCode(65 + index);

    Color backgroundColor;
    Color borderColor;
    IconData? icon;
    Color? iconColor;
    String? label;

    if (isCorrectAnswer) {
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green;
      icon = Icons.check_circle_rounded;
      iconColor = Colors.green;
      label = t.quiz_correct_answer;
    } else if (isUserAnswer && !isCorrectAnswer) {
      backgroundColor = Colors.red.withOpacity(0.1);
      borderColor = Colors.red;
      icon = Icons.cancel_rounded;
      iconColor = Colors.red;
      label = t.quiz_your_answer;
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest.withOpacity(0.3);
      borderColor = colorScheme.outline.withOpacity(0.2);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isCorrectAnswer || (isUserAnswer && !isCorrectAnswer) ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCorrectAnswer
                      ? Colors.green
                      : (isUserAnswer && !isCorrectAnswer)
                      ? Colors.red
                      : colorScheme.surface,
                  shape: BoxShape.circle,
                  border: !isCorrectAnswer && !isUserAnswer
                      ? Border.all(
                          color: colorScheme.outline.withOpacity(0.3),
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    optionLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isCorrectAnswer || (isUserAnswer && !isCorrectAnswer)
                          ? Colors.white
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface,
                    fontWeight: isCorrectAnswer || isUserAnswer
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: iconColor, size: 24),
            ],
          ),
          if (label != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: iconColor?.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
