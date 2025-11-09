import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';

class QuizQuestionScreen extends StatelessWidget {
  final QuizEntity quiz;
  final int currentQuestionIndex;
  final Map<int, int> selectedAnswers;
  final Duration? remainingTime;
  final bool isSubmitting;
  final Function(int) onAnswerSelected;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const QuizQuestionScreen({
    super.key,
    required this.quiz,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
    this.remainingTime,
    required this.isSubmitting,
    required this.onAnswerSelected,
    required this.onNext,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final currentQuestion = quiz.questions[currentQuestionIndex];
    final selectedAnswer = selectedAnswers[currentQuestionIndex];
    final canGoNext = currentQuestionIndex < quiz.questions.length - 1;
    final canGoPrevious = currentQuestionIndex > 0;
    final isLastQuestion = currentQuestionIndex == quiz.questions.length - 1;

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
                // Progress and Timer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Progress
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline_rounded,
                          size: 20,
                          color: colorScheme.primary,
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
                    // Timer
                    if (remainingTime != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getTimerColor(remainingTime!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              Formatter.formatDuration(
                                remainingTime!,
                                localization: t,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress Bar
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

          // Question Content
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
                  ...List.generate(
                    currentQuestion.options.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AnswerOption(
                        option: currentQuestion.options[index],
                        index: index,
                        isSelected: selectedAnswer == index,
                        onTap: () => onAnswerSelected(index),
                        colorScheme: colorScheme,
                      ),
                    ),
                  ),
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
            child: isSubmitting
                ? Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  )
                : Row(
                    children: [
                      // Previous Button
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

                      // Next/Submit Button
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: isLastQuestion ? onSubmit : onNext,
                          icon: Icon(
                            isLastQuestion
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                          label: Text(
                            isLastQuestion ? t.quiz_submit : t.quiz_next,
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Color _getTimerColor(Duration remaining) {
    final totalSeconds = quiz.timeLimit.inSeconds;
    final remainingSeconds = remaining.inSeconds;
    final percentage = remainingSeconds / totalSeconds;

    if (percentage > 0.5) {
      return Colors.green;
    } else if (percentage > 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

class _AnswerOption extends StatelessWidget {
  final String option;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _AnswerOption({
    required this.option,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final optionLabel = String.fromCharCode(65 + index); // A, B, C, D

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Option Label
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.surface,
                shape: BoxShape.circle,
                border: !isSelected
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
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Option Text
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // Checkmark
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
