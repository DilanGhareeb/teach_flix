import 'package:teach_flix/src/features/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/features/courses/data/models/video_model.dart';
import 'package:teach_flix/src/features/courses/data/models/quiz_model.dart';

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required super.id,
    required super.title,
    required super.videosUrls,
    required super.quizzes,
  });

  factory ChapterModel.fromEntity(ChapterEntity entity) {
    return ChapterModel(
      id: entity.id,
      title: entity.title,
      videosUrls: entity.videosUrls,
      quizzes: entity.quizzes,
    );
  }

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'] as String,
      title: map['title'] as String,
      videosUrls: (map['videosUrls'] as List<dynamic>)
          .map((video) => VideoModel.fromMap(video as Map<String, dynamic>))
          .toList(),
      quizzes: (map['quizzes'] as List<dynamic>)
          .map((quiz) => QuizModel.fromMap(quiz as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'videosUrls': videosUrls
          .map((video) => VideoModel.fromEntity(video).toMap())
          .toList(),
      'quizzes': quizzes
          .map((quiz) => QuizModel.fromEntity(quiz).toMap())
          .toList(),
    };
  }
}
