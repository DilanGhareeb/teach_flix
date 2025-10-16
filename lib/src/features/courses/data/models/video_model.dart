import 'package:teach_flix/src/features/courses/domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.title,
    required super.youtubeUrl,
    required super.orderIndex,
  });

  factory VideoModel.fromEntity(VideoEntity entity) {
    return VideoModel(
      id: entity.id,
      title: entity.title,
      youtubeUrl: entity.youtubeUrl,
      orderIndex: entity.orderIndex,
    );
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      youtubeUrl: map['youtubeUrl'] as String,
      orderIndex: map['orderIndex'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'youtubeUrl': youtubeUrl,
      'orderIndex': orderIndex,
    };
  }
}
