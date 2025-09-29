import 'package:teach_flix/src/fatures/courses/domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.question,
    required super.options,
    required super.correctAnswerIndex,
    required super.explanation,
  });

  factory QuestionModel.fromEntity(QuestionEntity entity) {
    return QuestionModel(
      id: entity.id,
      question: entity.question,
      options: entity.options,
      correctAnswerIndex: entity.correctAnswerIndex,
      explanation: entity.explanation,
    );
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as String,
      question: map['question'] as String,
      options: List<String>.from(map['options'] as List<dynamic>),
      correctAnswerIndex: map['correctAnswerIndex'] as int,
      explanation: map['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }
}
