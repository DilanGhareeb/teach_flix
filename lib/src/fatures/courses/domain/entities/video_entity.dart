import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String title;
  final String youtubeUrl;
  final Duration duration;
  final String description;
  final int orderIndex;

  const VideoEntity({
    required this.id,
    required this.title,
    required this.youtubeUrl,
    required this.duration,
    required this.description,
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    youtubeUrl,
    duration,
    description,
    orderIndex,
  ];
}
