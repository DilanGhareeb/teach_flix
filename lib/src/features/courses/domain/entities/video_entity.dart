import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String title;
  final String youtubeUrl;
  final int orderIndex;

  const VideoEntity({
    required this.id,
    required this.title,
    required this.youtubeUrl,
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [id, title, youtubeUrl, orderIndex];
}
