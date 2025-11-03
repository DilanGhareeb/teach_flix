import 'package:equatable/equatable.dart';

sealed class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgressEvent extends ProgressEvent {
  final String userId;
  final String courseId;

  const LoadProgressEvent({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}

class WatchProgressEvent extends ProgressEvent {
  final String userId;
  final String courseId;

  const WatchProgressEvent({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}

class ToggleVideoCompletionEvent extends ProgressEvent {
  final String userId;
  final String courseId;
  final String videoId;
  final bool isCompleted;
  final int totalItems;

  const ToggleVideoCompletionEvent({
    required this.userId,
    required this.courseId,
    required this.videoId,
    required this.isCompleted,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [
    userId,
    courseId,
    videoId,
    isCompleted,
    totalItems,
  ];
}

class ToggleQuizCompletionEvent extends ProgressEvent {
  final String userId;
  final String courseId;
  final String quizId;
  final bool isCompleted;
  final int totalItems;

  const ToggleQuizCompletionEvent({
    required this.userId,
    required this.courseId,
    required this.quizId,
    required this.isCompleted,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [
    userId,
    courseId,
    quizId,
    isCompleted,
    totalItems,
  ];
}

class InitializeProgressEvent extends ProgressEvent {
  final String userId;
  final String courseId;

  const InitializeProgressEvent({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}

class ResetProgressEvent extends ProgressEvent {
  final String userId;
  final String courseId;

  const ResetProgressEvent({required this.userId, required this.courseId});

  @override
  List<Object?> get props => [userId, courseId];
}

class LoadUserAllProgressEvent extends ProgressEvent {
  final String userId;

  const LoadUserAllProgressEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
