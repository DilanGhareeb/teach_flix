import 'package:equatable/equatable.dart';

class StudentProgressEntity extends Equatable {
  final String id;
  final String userId;
  final String courseId;
  final List<String> completedVideoIds;
  final List<String> completedQuizIds;
  final DateTime lastAccessedAt;
  final double progressPercentage;
  final DateTime createdAt;

  const StudentProgressEntity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.completedVideoIds,
    required this.completedQuizIds,
    required this.lastAccessedAt,
    required this.progressPercentage,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    courseId,
    completedVideoIds,
    completedQuizIds,
    lastAccessedAt,
    progressPercentage,
    createdAt,
  ];

  // Helper methods
  bool isVideoCompleted(String videoId) {
    return completedVideoIds.contains(videoId);
  }

  bool isQuizCompleted(String quizId) {
    return completedQuizIds.contains(quizId);
  }

  int get totalCompletedItems =>
      completedVideoIds.length + completedQuizIds.length;
}
