import 'package:teach_flix/src/fatures/courses/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/fatures/courses/data/models/question_model.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.title,
    required super.questions,
    required super.passingScore,
    required super.timeLimit,
  });

  factory QuizModel.fromEntity(QuizEntity entity) {
    return QuizModel(
      id: entity.id,
      title: entity.title,
      questions: entity.questions,
      passingScore: entity.passingScore,
      timeLimit: entity.timeLimit,
    );
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] as String,
      title: map['title'] as String,
      questions: (map['questions'] as List<dynamic>)
          .map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
          .toList(),
      passingScore: map['passingScore'] as int,
      timeLimit: Duration(minutes: map['timeLimitMinutes'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'questions': questions
          .map((q) => QuestionModel.fromEntity(q).toMap())
          .toList(),
      'passingScore': passingScore,
      'timeLimitMinutes': timeLimit.inMinutes,
    };
  }
}
