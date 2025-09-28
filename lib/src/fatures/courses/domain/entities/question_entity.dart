import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuestionEntity({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
    id,
    question,
    options,
    correctAnswerIndex,
    explanation,
  ];
}
