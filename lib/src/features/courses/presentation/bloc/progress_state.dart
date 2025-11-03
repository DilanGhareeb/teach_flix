import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/student_progress_entity.dart';

sealed class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final StudentProgressEntity progress;

  const ProgressLoaded({required this.progress});

  @override
  List<Object?> get props => [progress];
}

class ProgressError extends ProgressState {
  final Failure failure;

  const ProgressError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ProgressUpdating extends ProgressState {
  final StudentProgressEntity currentProgress;

  const ProgressUpdating({required this.currentProgress});

  @override
  List<Object?> get props => [currentProgress];
}

class ProgressUpdateSuccess extends ProgressState {
  final StudentProgressEntity progress;

  const ProgressUpdateSuccess({required this.progress});

  @override
  List<Object?> get props => [progress];
}

class ProgressUpdateError extends ProgressState {
  final Failure failure;
  final StudentProgressEntity? currentProgress;

  const ProgressUpdateError({required this.failure, this.currentProgress});

  @override
  List<Object?> get props => [failure, currentProgress];
}

class UserAllProgressLoaded extends ProgressState {
  final List<StudentProgressEntity> progressList;

  const UserAllProgressLoaded({required this.progressList});

  @override
  List<Object?> get props => [progressList];
}

class ProgressReset extends ProgressState {}
