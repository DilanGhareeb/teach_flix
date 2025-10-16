import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.courseId,
    required super.instructorId,
    required super.amount,
    required super.instructorProfit,
    required super.platformProfit,
    required super.type,
    required super.createdAt,
  });

  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] as String,
      courseId: data['courseId'] as String,
      instructorId: data['instructorId'] as String,
      amount: (data['amount'] as num).toDouble(),
      instructorProfit: (data['instructorProfit'] as num).toDouble(),
      platformProfit: (data['platformProfit'] as num).toDouble(),
      type: data['type'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      userId: entity.userId,
      courseId: entity.courseId,
      instructorId: entity.instructorId,
      amount: entity.amount,
      instructorProfit: entity.instructorProfit,
      platformProfit: entity.platformProfit,
      type: entity.type,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'instructorId': instructorId,
      'amount': amount,
      'instructorProfit': instructorProfit,
      'platformProfit': platformProfit,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    String? instructorId,
    double? amount,
    double? instructorProfit,
    double? platformProfit,
    String? type,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      instructorId: instructorId ?? this.instructorId,
      amount: amount ?? this.amount,
      instructorProfit: instructorProfit ?? this.instructorProfit,
      platformProfit: platformProfit ?? this.platformProfit,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
