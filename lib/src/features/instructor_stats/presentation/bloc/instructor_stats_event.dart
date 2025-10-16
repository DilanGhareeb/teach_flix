part of 'instructor_stats_bloc.dart';

abstract class InstructorStatsEvent extends Equatable {
  const InstructorStatsEvent();

  @override
  List<Object?> get props => [];
}

/// Load instructor stats for the first time or refresh
class InstructorStatsLoadRequested extends InstructorStatsEvent {
  final String instructorId;

  const InstructorStatsLoadRequested(this.instructorId);

  @override
  List<Object?> get props => [instructorId];
}

/// Start watching instructor stats for real-time updates
class InstructorStatsWatchStarted extends InstructorStatsEvent {
  final String instructorId;

  const InstructorStatsWatchStarted(this.instructorId);

  @override
  List<Object?> get props => [instructorId];
}

/// Stop watching instructor stats
class InstructorStatsWatchStopped extends InstructorStatsEvent {
  const InstructorStatsWatchStopped();
}

/// Load detailed stats for a specific course
class CourseStatsLoadRequested extends InstructorStatsEvent {
  final String courseId;

  const CourseStatsLoadRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

/// Load transaction history
class TransactionsLoadRequested extends InstructorStatsEvent {
  final String instructorId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;

  const TransactionsLoadRequested(
    this.instructorId, {
    this.startDate,
    this.endDate,
    this.limit,
  });

  @override
  List<Object?> get props => [instructorId, startDate, endDate, limit];
}

/// Internal event for real-time stats updates
class _InstructorStatsUpdated extends InstructorStatsEvent {
  final InstructorStatsEntity stats;

  const _InstructorStatsUpdated(this.stats);

  @override
  List<Object?> get props => [stats];
}
