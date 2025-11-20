import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/progress_checkbox.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_bloc.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_event.dart';
import 'package:teach_flix/src/features/quiz/view/pages/quiz_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class QuizzesList extends StatelessWidget {
  final CourseEntity course;
  final ColorScheme colorScheme;
  final String? userId;
  final int totalItems;

  const QuizzesList({
    super.key,
    required this.course,
    required this.colorScheme,
    this.userId,
    required this.totalItems,
  });

  void _navigateToQuiz(BuildContext context, QuizEntity quiz) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) {
          return BlocProvider.value(
            value: context.read<QuizBloc>()
              ..add(
                LoadQuizEvent(
                  quizId: quiz.id,
                  userId: userId!,
                  courseId: course.id,
                  totalItems: totalItems, // ✅ Pass totalItems
                ),
              ),
            child: QuizPage(
              quiz: quiz,
              userId: userId!,
              courseId: course.id,
              totalItems: totalItems,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (course.chapters.isEmpty ||
        course.chapters.every((c) => c.quizzes.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              t.no_quizzes_available ?? 'No quizzes available',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: course.chapters.length,
      itemBuilder: (context, chapterIndex) {
        final chapter = course.chapters[chapterIndex];

        if (chapter.quizzes.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              childrenPadding: const EdgeInsets.only(bottom: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.folder_outlined,
                  color: colorScheme.secondary,
                  size: 24,
                ),
              ),
              title: Text(
                chapter.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${chapter.quizzes.length} ${chapter.quizzes.length == 1 ? t.quiz : t.quizzes}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              children: chapter.quizzes.map((quiz) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.quiz,
                        color: colorScheme.secondary,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      quiz.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        t.quiz,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    // PROGRESS CHECKBOX TRAILING
                    trailing: userId != null
                        ? SizedBox(
                            width: 40,
                            child: ProgressCheckbox(
                              itemId: quiz.id,
                              itemType: 'quiz',
                              userId: userId!,
                              courseId: course.id,
                              totalItems: totalItems,
                              showTitle: false,
                            ),
                          )
                        : null,
                    onTap: () => _navigateToQuiz(context, quiz),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
