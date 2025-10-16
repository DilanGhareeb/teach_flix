part of 'instructor_stats_bloc.dart';

enum InstructorStatsStatus {
  initial,
  loading,
  success,
  failure,
  loadingTransactions,
  transactionsLoaded,
}

class InstructorStatsState extends Equatable {
  final InstructorStatsStatus status;
  final InstructorStatsEntity? stats;
  final CourseStatsEntity? selectedCourseStats;
  final List<TransactionEntity> transactions;
  final String? errorMessage;
  final bool isWatching;

  const InstructorStatsState({
    this.status = InstructorStatsStatus.initial,
    this.stats,
    this.selectedCourseStats,
    this.transactions = const [],
    this.errorMessage,
    this.isWatching = false,
  });

  @override
  List<Object?> get props => [
    status,
    stats,
    selectedCourseStats,
    transactions,
    errorMessage,
    isWatching,
  ];

  InstructorStatsState copyWith({
    InstructorStatsStatus? status,
    InstructorStatsEntity? stats,
    CourseStatsEntity? selectedCourseStats,
    List<TransactionEntity>? transactions,
    String? errorMessage,
    bool? isWatching,
  }) {
    return InstructorStatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      selectedCourseStats: selectedCourseStats ?? this.selectedCourseStats,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      isWatching: isWatching ?? this.isWatching,
    );
  }

  // Convenience getters
  bool get hasStats => stats != null;
  bool get hasTransactions => transactions.isNotEmpty;
  bool get isLoading => status == InstructorStatsStatus.loading;
  bool get isSuccess => status == InstructorStatsStatus.success;
  bool get isFailure => status == InstructorStatsStatus.failure;
}
