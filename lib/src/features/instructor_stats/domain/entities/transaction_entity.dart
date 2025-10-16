import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String userId;
  final String courseId;
  final String instructorId;
  final double amount;
  final double instructorProfit;
  final double platformProfit;
  final String type; // 'course_purchase' or 'free_enrollment'
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.instructorId,
    required this.amount,
    required this.instructorProfit,
    required this.platformProfit,
    required this.type,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    courseId,
    instructorId,
    amount,
    instructorProfit,
    platformProfit,
    type,
    createdAt,
  ];
}
