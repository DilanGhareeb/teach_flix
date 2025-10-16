import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/course_stats_entity.dart';

/// Represents profit data for a specific time period
class PeriodProfitData extends Equatable {
  final DateTime date;
  final double profit;

  const PeriodProfitData({required this.date, required this.profit});

  @override
  List<Object?> get props => [date, profit];
}

class InstructorStatsEntity extends Equatable {
  final String instructorId;
  final int totalCourses;
  final int totalStudents;
  final double todayProfit;
  final double monthProfit;
  final double yearProfit;
  final double totalProfit;
  final List<CourseStatsEntity> courseStats;
  final DateTime lastUpdated;
  final List<PeriodProfitData> last30DaysProfits;
  final List<PeriodProfitData> last12MonthsProfits;
  final List<PeriodProfitData> allTimeProfits;

  const InstructorStatsEntity({
    required this.instructorId,
    required this.totalCourses,
    required this.totalStudents,
    required this.todayProfit,
    required this.monthProfit,
    required this.yearProfit,
    required this.totalProfit,
    required this.courseStats,
    required this.lastUpdated,
    this.last30DaysProfits = const [],
    this.last12MonthsProfits = const [],
    this.allTimeProfits = const [],
  });

  @override
  List<Object?> get props => [
    instructorId,
    totalCourses,
    totalStudents,
    todayProfit,
    monthProfit,
    yearProfit,
    totalProfit,
    courseStats,
    lastUpdated,
    last30DaysProfits,
    last12MonthsProfits,
    allTimeProfits,
  ];

  InstructorStatsEntity copyWith({
    String? instructorId,
    int? totalCourses,
    int? totalStudents,
    double? todayProfit,
    double? monthProfit,
    double? yearProfit,
    double? totalProfit,
    List<CourseStatsEntity>? courseStats,
    DateTime? lastUpdated,
    List<PeriodProfitData>? last30DaysProfits,
    List<PeriodProfitData>? last12MonthsProfits,
    List<PeriodProfitData>? allTimeProfits,
  }) {
    return InstructorStatsEntity(
      instructorId: instructorId ?? this.instructorId,
      totalCourses: totalCourses ?? this.totalCourses,
      totalStudents: totalStudents ?? this.totalStudents,
      todayProfit: todayProfit ?? this.todayProfit,
      monthProfit: monthProfit ?? this.monthProfit,
      yearProfit: yearProfit ?? this.yearProfit,
      totalProfit: totalProfit ?? this.totalProfit,
      courseStats: courseStats ?? this.courseStats,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      last30DaysProfits: last30DaysProfits ?? this.last30DaysProfits,
      last12MonthsProfits: last12MonthsProfits ?? this.last12MonthsProfits,
      allTimeProfits: allTimeProfits ?? this.allTimeProfits,
    );
  }
}
