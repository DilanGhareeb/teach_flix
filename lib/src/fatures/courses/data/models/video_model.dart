import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.title,
    required super.youtubeUrl,
    required super.orderIndex,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      youtubeUrl: map['youtubeUrl'] ?? '',
      orderIndex: map['orderIndex'] ?? 0,
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
