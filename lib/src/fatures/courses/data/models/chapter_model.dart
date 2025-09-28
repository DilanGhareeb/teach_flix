import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/data/models/video_model.dart';
import 'package:teach_flix/src/fatures/courses/data/models/quiz_model.dart';

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required super.id,
    required super.title,
    required super.videosUrls,
    required super.quizzes,
  });

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      videosUrls: (map['videosUrls'] as List<dynamic>? ?? [])
          .map((video) => VideoModel.fromMap(video))
          .toList(),
      quizzes: (map['quizzes'] as List<dynamic>? ?? [])
          .map((quiz) => QuizModel.fromMap(quiz))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'videosUrls': videosUrls
          .map((video) => (video as VideoModel).toMap())
          .toList(),
      'quizzes': quizzes.map((quiz) => (quiz as QuizModel).toMap()).toList(),
    };
  }
}
