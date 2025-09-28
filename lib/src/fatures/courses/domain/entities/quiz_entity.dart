import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/question_entity.dart';

class QuizEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<QuestionEntity> questions;
  final int passingScore;
  final Duration timeLimit;

  const QuizEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.passingScore,
    required this.timeLimit,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    questions,
    passingScore,
    timeLimit,
  ];
}
