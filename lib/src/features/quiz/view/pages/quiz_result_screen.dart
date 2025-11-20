import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'dart:math' as math;

class QuizResultScreen extends StatelessWidget {
  final QuizResultEntity result;
  final QuizEntity quiz;
  final VoidCallback onReview;
  final VoidCallback onRetake;
  final VoidCallback onClose;

  const QuizResultScreen({
    super.key,
    required this.result,
    required this.quiz,
    required this.onReview,
    required this.onRetake,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final passed = result.passed;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Result Icon with Animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: passed
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        passed
                            ? Icons.emoji_events_rounded
                            : Icons.refresh_rounded,
                        size: 60,
                        color: passed ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Result Title
                  Text(
                    passed ? t.quiz_passed : t.quiz_failed,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Result Message
                  Text(
                    passed ? t.quiz_passed_message : t.quiz_failed_message,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Score Circle
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1200),
                        tween: Tween(begin: 0.0, end: result.percentage / 100),
                        builder: (context, value, child) {
                          return CustomPaint(
                            painter: _CircularScorePainter(
                              progress: value,
                              primaryColor: colorScheme.primary,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(value * 100).toInt()}%',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '${result.score}/${result.totalQuestions}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.timer_outlined,
                          title: t.quiz_time_taken,
                          value: Formatter.formatDuration(
                            result.timeTaken,
                            localization: t,
                          ),
                          colorScheme: colorScheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle_outline_rounded,
                          title: t.quiz_correct_answers,
                          value: '${result.score}',
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.cancel_outlined,
                          title: t.quiz_wrong_answers,
                          value: '${result.totalQuestions - result.score}',
                          colorScheme: colorScheme,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Actions
                  FilledButton.icon(
                    onPressed: onReview,
                    icon: const Icon(Icons.visibility_outlined),
                    label: Text(t.quiz_review_answers),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onRetake,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(t.quiz_retake),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(onPressed: onClose, child: Text(t.close)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final ColorScheme colorScheme;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularScorePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color backgroundColor;

  _CircularScorePainter({
    required this.progress,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 12.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _CircularScorePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
