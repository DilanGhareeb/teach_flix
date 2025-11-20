import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/features/quiz/domain/entities/question_entity.dart';

class QuizEntity extends Equatable {
  final String id;
  final String title;
  final List<QuestionEntity> questions;
  final Duration timeLimit;

  const QuizEntity({
    required this.id,
    required this.title,
    required this.questions,
    required this.timeLimit,
  });

  @override
  List<Object?> get props => [id, title, questions, timeLimit];
}
