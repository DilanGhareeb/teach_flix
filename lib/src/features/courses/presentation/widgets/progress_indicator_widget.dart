import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_state.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/certificate_download_button.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/core/utils/certificate_generator.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/certificate_viewer_dialog.dart'; // Add this import

class ProgressIndicatorWidget extends StatefulWidget {
  final String courseId;
  final bool showPercentage;
  final bool showItemsCount;

  const ProgressIndicatorWidget({
    super.key,
    required this.courseId,
    this.showPercentage = true,
    this.showItemsCount = false,
  });

  @override
  State<ProgressIndicatorWidget> createState() =>
      _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: _currentProgress)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateProgress(double newProgress) {
    if (_currentProgress != newProgress) {
      setState(() {
        _progressAnimation =
            Tween<double>(begin: _currentProgress, end: newProgress).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOutCubic,
              ),
            );
        _currentProgress = newProgress;
      });
      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state is ProgressLoading) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        if (state is ProgressLoaded || state is ProgressUpdating) {
          final progress = state is ProgressLoaded
              ? state.progress
              : (state as ProgressUpdating).currentProgress;

          final percentage = progress.progressPercentage;
          final completedCount = progress.totalCompletedItems;
          final isComplete = percentage >= 100;

          // Update animation when percentage changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateProgress(percentage / 100);
          });

          return AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              final animatedPercentage = _progressAnimation.value * 100;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Bar with Gradient
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                // Background
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest
                                        .withOpacity(0.5),
                                  ),
                                ),
                                // Animated Progress with Gradient
                                FractionallySizedBox(
                                  widthFactor: _progressAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isComplete
                                            ? [
                                                Colors.green.shade400,
                                                Colors.green.shade600,
                                              ]
                                            : [
                                                colorScheme.primary,
                                                colorScheme.primary.withOpacity(
                                                  0.7,
                                                ),
                                              ],
                                      ),
                                    ),
                                    child: _progressAnimation.value > 0.05
                                        ? _buildShimmerEffect()
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (widget.showPercentage) ...[
                        const SizedBox(width: 16),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: animatedPercentage,
                          ),
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isComplete
                                    ? Colors.green.withOpacity(0.15)
                                    : colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isComplete
                                      ? Colors.green
                                      : colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '${value.toStringAsFixed(0)}%',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isComplete
                                          ? Colors.green.shade700
                                          : colorScheme.onPrimary,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),

                  // Items Count
                  if (widget.showItemsCount) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$completedCount items completed',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ],

                  // Completion Celebration with Certificate Button
                  if (isComplete) ...[
                    const SizedBox(height: 12),
                    _buildCompletionBadge(colorScheme, t),
                  ],
                ],
              );
            },
          );
        }

        if (state is ProgressError) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.error,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerEffect() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: -1.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return FractionallySizedBox(
          widthFactor: 0.3,
          alignment: Alignment(value, 0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop the shimmer effect
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildCompletionBadge(ColorScheme colorScheme, AppLocalizations t) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            children: [
              // Completion message
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.celebration,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      t.progress_course_completed,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('🎉', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),

              // Certificate download button
              const SizedBox(height: 12),
              CertificateDownloadButton(courseId: widget.courseId),
            ],
          ),
        );
      },
    );
  }
}
