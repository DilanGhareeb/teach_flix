import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/courses/domain/entities/student_progress_entity.dart';

class StudentProgressModel extends StudentProgressEntity {
  const StudentProgressModel({
    required super.id,
    required super.userId,
    required super.courseId,
    required super.completedVideoIds,
    required super.completedQuizIds,
    required super.lastAccessedAt,
    required super.progressPercentage,
    required super.createdAt,
  });

  factory StudentProgressModel.fromEntity(StudentProgressEntity entity) {
    return StudentProgressModel(
      id: entity.id,
      userId: entity.userId,
      courseId: entity.courseId,
      completedVideoIds: entity.completedVideoIds,
      completedQuizIds: entity.completedQuizIds,
      lastAccessedAt: entity.lastAccessedAt,
      progressPercentage: entity.progressPercentage,
      createdAt: entity.createdAt,
    );
  }

  factory StudentProgressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StudentProgressModel(
      id: doc.id,
      userId: data['userId'] as String,
      courseId: data['courseId'] as String,
      completedVideoIds: List<String>.from(data['completedVideoIds'] ?? []),
      completedQuizIds: List<String>.from(data['completedQuizIds'] ?? []),
      lastAccessedAt: (data['lastAccessedAt'] as Timestamp).toDate(),
      progressPercentage: (data['progressPercentage'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'courseId': courseId,
      'completedVideoIds': completedVideoIds,
      'completedQuizIds': completedQuizIds,
      'lastAccessedAt': Timestamp.fromDate(lastAccessedAt),
      'progressPercentage': progressPercentage,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  StudentProgressModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    List<String>? completedVideoIds,
    List<String>? completedQuizIds,
    DateTime? lastAccessedAt,
    double? progressPercentage,
    DateTime? createdAt,
  }) {
    return StudentProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      completedVideoIds: completedVideoIds ?? this.completedVideoIds,
      completedQuizIds: completedQuizIds ?? this.completedQuizIds,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
