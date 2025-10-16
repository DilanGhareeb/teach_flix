import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/instructor_stats_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/transaction_entity.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_course_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_instructor_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_instructor_transactions.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/watch_instructor_stats.dart';

part 'instructor_stats_event.dart';
part 'instructor_stats_state.dart';

class InstructorStatsBloc
    extends Bloc<InstructorStatsEvent, InstructorStatsState> {
  final GetInstructorStats _getInstructorStats;
  final GetCourseStats _getCourseStats;
  final GetInstructorTransactions _getInstructorTransactions;
  final WatchInstructorStats _watchInstructorStats;

  StreamSubscription<dynamic>? _statsSubscription;
  bool _isClosing = false;

  InstructorStatsBloc({
    required GetInstructorStats getInstructorStats,
    required GetCourseStats getCourseStats,
    required GetInstructorTransactions getInstructorTransactions,
    required WatchInstructorStats watchInstructorStats,
  }) : _getInstructorStats = getInstructorStats,
       _getCourseStats = getCourseStats,
       _getInstructorTransactions = getInstructorTransactions,
       _watchInstructorStats = watchInstructorStats,
       super(const InstructorStatsState()) {
    on<InstructorStatsLoadRequested>(_onLoadRequested);
    on<InstructorStatsWatchStarted>(_onWatchStarted);
    on<InstructorStatsWatchStopped>(_onWatchStopped);
    on<CourseStatsLoadRequested>(_onCourseStatsLoadRequested);
    on<TransactionsLoadRequested>(_onTransactionsLoadRequested);
    on<_InstructorStatsUpdated>(_onStatsUpdated);
  }

  /// Handle loading instructor stats
  Future<void> _onLoadRequested(
    InstructorStatsLoadRequested event,
    Emitter<InstructorStatsState> emit,
  ) async {
    if (_isClosing) return;

    emit(
      state.copyWith(status: InstructorStatsStatus.loading, errorMessage: null),
    );

    final result = await _getInstructorStats(event.instructorId);

    if (_isClosing) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InstructorStatsStatus.failure,
          errorMessage: _mapFailureToMessage(failure),
        ),
      ),
      (stats) => emit(
        state.copyWith(status: InstructorStatsStatus.success, stats: stats),
      ),
    );
  }

  Future<void> _onWatchStarted(
    InstructorStatsWatchStarted event,
    Emitter<InstructorStatsState> emit,
  ) async {
    if (_isClosing) return;

    // Cancel any existing subscription
    await _statsSubscription?.cancel();
    _statsSubscription = null;

    emit(
      state.copyWith(
        status: InstructorStatsStatus.loading,
        isWatching: true,
        errorMessage: null,
      ),
    );

    // Start watching the stats stream
    _statsSubscription = _watchInstructorStats(event.instructorId).listen(
      (result) {
        // CRITICAL: Check both isClosed AND _isClosing
        if (!isClosed && !_isClosing) {
          result.fold(
            (failure) {
              add(
                _InstructorStatsUpdated(
                  state.stats ?? _getEmptyStats(event.instructorId),
                ),
              );
            },
            (stats) {
              add(_InstructorStatsUpdated(stats));
            },
          );
        }
      },
      onError: (error) {
        // CRITICAL: Check both isClosed AND _isClosing
        if (!isClosed && !_isClosing) {
          add(
            _InstructorStatsUpdated(
              state.stats ?? _getEmptyStats(event.instructorId),
            ),
          );
        }
      },
      cancelOnError: false,
    );
  }

  /// Handle stopping real-time stats watching
  Future<void> _onWatchStopped(
    InstructorStatsWatchStopped event,
    Emitter<InstructorStatsState> emit,
  ) async {
    if (_isClosing) return;

    await _statsSubscription?.cancel();
    _statsSubscription = null;

    emit(state.copyWith(isWatching: false));
  }

  /// Handle internal stats updates from stream
  void _onStatsUpdated(
    _InstructorStatsUpdated event,
    Emitter<InstructorStatsState> emit,
  ) {
    if (_isClosing) return;

    emit(
      state.copyWith(status: InstructorStatsStatus.success, stats: event.stats),
    );
  }

  /// Handle loading course-specific stats
  Future<void> _onCourseStatsLoadRequested(
    CourseStatsLoadRequested event,
    Emitter<InstructorStatsState> emit,
  ) async {
    if (_isClosing) return;

    emit(
      state.copyWith(status: InstructorStatsStatus.loading, errorMessage: null),
    );

    final result = await _getCourseStats(event.courseId);

    if (_isClosing) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InstructorStatsStatus.failure,
          errorMessage: _mapFailureToMessage(failure),
        ),
      ),
      (courseStats) => emit(
        state.copyWith(
          status: InstructorStatsStatus.success,
          selectedCourseStats: courseStats,
        ),
      ),
    );
  }

  /// Handle loading transaction history
  Future<void> _onTransactionsLoadRequested(
    TransactionsLoadRequested event,
    Emitter<InstructorStatsState> emit,
  ) async {
    if (_isClosing) return;

    emit(
      state.copyWith(
        status: InstructorStatsStatus.loadingTransactions,
        errorMessage: null,
      ),
    );

    final result = await _getInstructorTransactions(
      event.instructorId,
      startDate: event.startDate,
      endDate: event.endDate,
      limit: event.limit,
    );

    if (_isClosing) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InstructorStatsStatus.failure,
          errorMessage: _mapFailureToMessage(failure),
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          status: InstructorStatsStatus.transactionsLoaded,
          transactions: transactions,
        ),
      ),
    );
  }

  /// Map failures to user-friendly messages
  String _mapFailureToMessage(dynamic failure) {
    return failure.toString();
  }

  /// Create an empty stats object for fallback
  InstructorStatsEntity _getEmptyStats(String instructorId) {
    return InstructorStatsEntity(
      instructorId: instructorId,
      totalCourses: 0,
      totalStudents: 0,
      todayProfit: 0.0,
      monthProfit: 0.0,
      yearProfit: 0.0,
      totalProfit: 0.0,
      courseStats: const [],
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<void> close() async {
    _isClosing = true;

    // Cancel subscription and give it time to complete
    await _statsSubscription?.cancel();
    _statsSubscription = null;

    // Small delay to ensure all pending events are processed
    await Future.delayed(const Duration(milliseconds: 50));

    return super.close();
  }
}
