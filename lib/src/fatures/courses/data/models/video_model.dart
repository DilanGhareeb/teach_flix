import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.title,
    required super.youtubeUrl,
    required super.duration,
    required super.description,
    required super.orderIndex,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      youtubeUrl: map['youtubeUrl'] ?? '',
      duration: Duration(seconds: map['duration'] ?? 0),
      description: map['description'] ?? '',
      orderIndex: map['orderIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'youtubeUrl': youtubeUrl,
      'duration': duration.inSeconds,
      'description': description,
      'orderIndex': orderIndex,
    };
  }
}
