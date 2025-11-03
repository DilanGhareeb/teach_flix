import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_event.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_state.dart';

class ProgressCheckbox extends StatelessWidget {
  final String itemId;
  final String itemType;
  final String userId;
  final String courseId;
  final int totalItems;
  final String? title;
  final bool showTitle;

  const ProgressCheckbox({
    super.key,
    required this.itemId,
    required this.itemType,
    required this.userId,
    required this.courseId,
    required this.totalItems,
    this.title,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        bool isCompleted = false;
        bool isLoading = false;

        if (state is ProgressLoaded) {
          isCompleted = itemType == 'video'
              ? state.progress.isVideoCompleted(itemId)
              : state.progress.isQuizCompleted(itemId);
        } else if (state is ProgressUpdating) {
          isCompleted = itemType == 'video'
              ? state.currentProgress.isVideoCompleted(itemId)
              : state.currentProgress.isQuizCompleted(itemId);
          isLoading = true;
        }

        return InkWell(
          onTap: isLoading
              ? null
              : () {
                  // Toggle the completion status
                  if (itemType == 'video') {
                    context.read<ProgressBloc>().add(
                      ToggleVideoCompletionEvent(
                        userId: userId,
                        courseId: courseId,
                        videoId: itemId,
                        isCompleted: !isCompleted, // Toggle
                        totalItems: totalItems,
                      ),
                    );
                  } else {
                    context.read<ProgressBloc>().add(
                      ToggleQuizCompletionEvent(
                        userId: userId,
                        courseId: courseId,
                        quizId: itemId,
                        isCompleted: !isCompleted, // Toggle
                        totalItems: totalItems,
                      ),
                    );
                  }
                },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.primary,
                    ),
                  )
                : Icon(
                    isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isCompleted
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.6),
                    size: 24,
                  ),
          ),
        );
      },
    );
  }
}
