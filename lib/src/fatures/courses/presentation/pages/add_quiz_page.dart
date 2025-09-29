import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/question_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class AddQuizPage extends StatefulWidget {
  const AddQuizPage({super.key});

  @override
  State<AddQuizPage> createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passingScoreController = TextEditingController();
  final _timeLimitController = TextEditingController();

  final List<QuestionEntity> _questions = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _passingScoreController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.add_quiz),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _saveQuiz,
            icon: const Icon(Icons.check_circle_rounded),
            label: Text(t.save),
            style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Quiz Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: t.quiz_title,
                hintText: t.enter_quiz_title,
                prefixIcon: Icon(
                  Icons.quiz_rounded,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return t.title_required;
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Passing Score
            TextFormField(
              controller: _passingScoreController,
              decoration: InputDecoration(
                labelText: t.passing_score,
                hintText: t.enter_passing_score,
                prefixIcon: Icon(
                  Icons.grade_rounded,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return t.passing_score_required;
                }
                if (int.tryParse(value!) == null) {
                  return t.invalid_passing_score;
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Time Limit
            TextFormField(
              controller: _timeLimitController,
              decoration: InputDecoration(
                labelText: t.time_limit_minutes,
                hintText: t.enter_time_limit,
                prefixIcon: Icon(
                  Icons.timer_rounded,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return t.time_limit_required;
                }
                if (int.tryParse(value!) == null) {
                  return t.invalid_time_limit;
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Questions Section
            _buildQuestionsSection(colorScheme, t),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsSection(ColorScheme colorScheme, AppLocalizations t) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.questions,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_questions.length}',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _addQuestion,
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          if (_questions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t.no_questions_added,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _questions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      question.question,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${question.options.length} options',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red[400],
                      ),
                      onPressed: () => _removeQuestion(index),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...question.options.asMap().entries.map((entry) {
                              final isCorrect =
                                  entry.key == question.correctAnswerIndex;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      isCorrect
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: isCorrect
                                          ? Colors.green
                                          : colorScheme.onSurface.withOpacity(
                                              0.5,
                                            ),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        entry.value,
                                        style: TextStyle(
                                          fontWeight: isCorrect
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isCorrect
                                              ? Colors.green
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            if (question.explanation.isNotEmpty) ...[
                              const Divider(),
                              Text(
                                t.explanation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(question.explanation),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) => _AddQuestionDialog(
        onAdd: (question) {
          setState(() {
            _questions.add(question);
          });
        },
      ),
    );
  }

  void _removeQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_question),
        content: Text(
          AppLocalizations.of(context)!.delete_question_confirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _questions.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _saveQuiz() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.add_at_least_one_question,
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final quiz = QuizEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        questions: _questions,
        passingScore: int.parse(_passingScoreController.text),
        timeLimit: Duration(minutes: int.parse(_timeLimitController.text)),
      );

      Navigator.pop(context, quiz);
    }
  }
}

// Add Question Dialog
class _AddQuestionDialog extends StatefulWidget {
  final Function(QuestionEntity) onAdd;

  const _AddQuestionDialog({required this.onAdd});

  @override
  State<_AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<_AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _explanationController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int _correctAnswerIndex = 0;

  @override
  void dispose() {
    _questionController.dispose();
    _explanationController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(t.add_question),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: t.question,
                  hintText: t.enter_question,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return t.question_required;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Options
              Text(
                t.options,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: _correctAnswerIndex,
                        onChanged: (value) {
                          setState(() {
                            _correctAnswerIndex = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            labelText: '${t.option} ${index + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: _correctAnswerIndex == index,
                            fillColor: _correctAnswerIndex == index
                                ? Colors.green.withOpacity(0.1)
                                : null,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return t.option_required;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Explanation
              TextFormField(
                controller: _explanationController,
                decoration: InputDecoration(
                  labelText: '${t.explanation} (${t.optional})',
                  hintText: t.enter_explanation,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        ElevatedButton(onPressed: _addQuestion, child: Text(t.add)),
      ],
    );
  }

  void _addQuestion() {
    if (_formKey.currentState?.validate() ?? false) {
      final question = QuestionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: _questionController.text,
        options: _optionControllers.map((c) => c.text).toList(),
        correctAnswerIndex: _correctAnswerIndex,
        explanation: _explanationController.text,
      );

      widget.onAdd(question);
      Navigator.pop(context);
    }
  }
}
