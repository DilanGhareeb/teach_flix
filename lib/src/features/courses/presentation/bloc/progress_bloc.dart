import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_user_all_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/initialize_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/reset_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/toggle_quiz_completion_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/toggle_video_completion_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/watch_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_event.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetProgress getProgress;
  final WatchProgress watchProgress;
  final ToggleVideoCompletion toggleVideoCompletion;
  final ToggleQuizCompletion toggleQuizCompletion;
  final InitializeProgress initializeProgress;
  final ResetProgress resetProgress;
  final GetUserAllProgress getUserAllProgress;

  StreamSubscription? _progressSubscription;

  ProgressBloc({
    required this.getProgress,
    required this.watchProgress,
    required this.toggleVideoCompletion,
    required this.toggleQuizCompletion,
    required this.initializeProgress,
    required this.resetProgress,
    required this.getUserAllProgress,
  }) : super(ProgressInitial()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<WatchProgressEvent>(_onWatchProgress);
    on<ToggleVideoCompletionEvent>(_onToggleVideoCompletion);
    on<ToggleQuizCompletionEvent>(_onToggleQuizCompletion);
    on<InitializeProgressEvent>(_onInitializeProgress);
    on<ResetProgressEvent>(_onResetProgress);
    on<LoadUserAllProgressEvent>(_onLoadUserAllProgress);
  }

  Future<void> _onLoadProgress(
    LoadProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());

    final result = await getProgress(
      userId: event.userId,
      courseId: event.courseId,
    );

    result.fold(
      (failure) => emit(ProgressError(failure: failure)),
      (progress) => emit(ProgressLoaded(progress: progress)),
    );
  }

  Future<void> _onWatchProgress(
    WatchProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    await _progressSubscription?.cancel();

    emit(ProgressLoading());

    _progressSubscription =
        watchProgress(userId: event.userId, courseId: event.courseId).listen((
          either,
        ) {
          either.fold(
            (failure) => add(
              LoadProgressEvent(userId: event.userId, courseId: event.courseId),
            ),
            (progress) => add(
              LoadProgressEvent(userId: event.userId, courseId: event.courseId),
            ),
          );
        });
  }

  Future<void> _onToggleVideoCompletion(
    ToggleVideoCompletionEvent event,
    Emitter<ProgressState> emit,
  ) async {
    // Show updating state with current progress
    if (state is ProgressLoaded) {
      emit(
        ProgressUpdating(currentProgress: (state as ProgressLoaded).progress),
      );
    }

    final result = await toggleVideoCompletion(
      userId: event.userId,
      courseId: event.courseId,
      videoId: event.videoId,
      isCompleted: event.isCompleted,
      totalItems: event.totalItems,
    );

    result.fold(
      (failure) {
        if (state is ProgressUpdating) {
          emit(
            ProgressUpdateError(
              failure: failure,
              currentProgress: (state as ProgressUpdating).currentProgress,
            ),
          );
        } else {
          emit(ProgressUpdateError(failure: failure));
        }
      },
      (_) {
        // Reload progress after successful update
        add(LoadProgressEvent(userId: event.userId, courseId: event.courseId));
      },
    );
  }

  Future<void> _onToggleQuizCompletion(
    ToggleQuizCompletionEvent event,
    Emitter<ProgressState> emit,
  ) async {
    // Show updating state with current progress
    if (state is ProgressLoaded) {
      emit(
        ProgressUpdating(currentProgress: (state as ProgressLoaded).progress),
      );
    }

    final result = await toggleQuizCompletion(
      userId: event.userId,
      courseId: event.courseId,
      quizId: event.quizId,
      isCompleted: event.isCompleted,
      totalItems: event.totalItems,
    );

    result.fold(
      (failure) {
        if (state is ProgressUpdating) {
          emit(
            ProgressUpdateError(
              failure: failure,
              currentProgress: (state as ProgressUpdating).currentProgress,
            ),
          );
        } else {
          emit(ProgressUpdateError(failure: failure));
        }
      },
      (_) {
        // Reload progress after successful update
        add(LoadProgressEvent(userId: event.userId, courseId: event.courseId));
      },
    );
  }

  Future<void> _onInitializeProgress(
    InitializeProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());

    final result = await initializeProgress(
      userId: event.userId,
      courseId: event.courseId,
    );

    result.fold(
      (failure) => emit(ProgressError(failure: failure)),
      (progress) => emit(ProgressLoaded(progress: progress)),
    );
  }

  Future<void> _onResetProgress(
    ResetProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    if (state is ProgressLoaded) {
      emit(
        ProgressUpdating(currentProgress: (state as ProgressLoaded).progress),
      );
    }

    final result = await resetProgress(
      userId: event.userId,
      courseId: event.courseId,
    );

    result.fold((failure) => emit(ProgressUpdateError(failure: failure)), (_) {
      emit(ProgressReset());
      // Reload progress after reset
      add(LoadProgressEvent(userId: event.userId, courseId: event.courseId));
    });
  }

  Future<void> _onLoadUserAllProgress(
    LoadUserAllProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());

    final result = await getUserAllProgress(userId: event.userId);

    result.fold(
      (failure) => emit(ProgressError(failure: failure)),
      (progressList) => emit(UserAllProgressLoaded(progressList: progressList)),
    );
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }
}
