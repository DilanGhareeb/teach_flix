import 'package:teach_flix/src/fatures/courses/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/fatures/courses/data/models/question_model.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.title,
    required super.description,
    required super.questions,
    required super.passingScore,
    required super.timeLimit,
  });

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      questions: (map['questions'] as List<dynamic>? ?? [])
          .map((question) => QuestionModel.fromMap(question))
          .toList(),
      passingScore: map['passingScore'] ?? 0,
      timeLimit: Duration(minutes: map['timeLimit'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions
          .map((question) => (question as QuestionModel).toMap())
          .toList(),
      'passingScore': passingScore,
      'timeLimit': timeLimit.inMinutes,
    };
  }
}
