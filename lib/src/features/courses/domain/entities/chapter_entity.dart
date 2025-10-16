import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/features/courses/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/video_entity.dart';

class ChapterEntity extends Equatable {
  final String id;
  final String title;
  final List<VideoEntity> videosUrls;
  final List<QuizEntity> quizzes;

  const ChapterEntity({
    required this.id,
    required this.title,
    required this.videosUrls,
    required this.quizzes,
  });

  @override
  List<Object?> get props => [id, title, videosUrls, quizzes];
}
