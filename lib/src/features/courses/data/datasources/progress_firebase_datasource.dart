import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/courses/data/models/student_progress_model.dart';

abstract class ProgressFirebaseDataSource {
  Future<StudentProgressModel> getProgress({
    required String userId,
    required String courseId,
  });

  Stream<StudentProgressModel> watchProgress({
    required String userId,
    required String courseId,
  });

  Future<void> markVideoAsCompleted({
    required String userId,
    required String courseId,
    required String videoId,
  });

  Future<void> markVideoAsUncompleted({
    required String userId,
    required String courseId,
    required String videoId,
  });

  Future<void> markQuizAsCompleted({
    required String userId,
    required String courseId,
    required String quizId,
  });

  Future<void> markQuizAsUncompleted({
    required String userId,
    required String courseId,
    required String quizId,
  });

  Future<void> updateProgressPercentage({
    required String userId,
    required String courseId,
    required int totalItems,
  });

  Future<List<StudentProgressModel>> getUserAllProgress({
    required String userId,
  });

  Future<StudentProgressModel> initializeProgress({
    required String userId,
    required String courseId,
  });

  Future<void> resetProgress({
    required String userId,
    required String courseId,
  });
}

class ProgressFirebaseDataSourceImpl implements ProgressFirebaseDataSource {
  final FirebaseFirestore firestore;

  ProgressFirebaseDataSourceImpl({required this.firestore});

  CollectionReference get _progressCollection =>
      firestore.collection('student_progress');

  String _getProgressId(String userId, String courseId) =>
      '${userId}_$courseId';

  @override
  Future<StudentProgressModel> getProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);
      final doc = await _progressCollection.doc(progressId).get();

      if (!doc.exists) {
        // Initialize progress if not exists
        return await initializeProgress(userId: userId, courseId: courseId);
      }

      return StudentProgressModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get progress: $e');
    }
  }

  @override
  Stream<StudentProgressModel> watchProgress({
    required String userId,
    required String courseId,
  }) {
    try {
      final progressId = _getProgressId(userId, courseId);

      return _progressCollection.doc(progressId).snapshots().asyncMap((
        doc,
      ) async {
        if (!doc.exists) {
          // Initialize progress if not exists
          return await initializeProgress(userId: userId, courseId: courseId);
        }
        return StudentProgressModel.fromFirestore(doc);
      });
    } catch (e) {
      throw Exception('Failed to watch progress: $e');
    }
  }

  @override
  Future<void> markVideoAsCompleted({
    required String userId,
    required String courseId,
    required String videoId,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);

      await _progressCollection.doc(progressId).update({
        'completedVideoIds': FieldValue.arrayUnion([videoId]),
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark video as completed: $e');
    }
  }

  @override
  Future<void> markVideoAsUncompleted({
    required String userId,
    required String courseId,
    required String videoId,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);

      await _progressCollection.doc(progressId).update({
        'completedVideoIds': FieldValue.arrayRemove([videoId]),
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark video as uncompleted: $e');
    }
  }

  @override
  Future<void> markQuizAsCompleted({
    required String userId,
    required String courseId,
    required String quizId,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);

      await _progressCollection.doc(progressId).update({
        'completedQuizIds': FieldValue.arrayUnion([quizId]),
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark quiz as completed: $e');
    }
  }

  @override
  Future<void> markQuizAsUncompleted({
    required String userId,
    required String courseId,
    required String quizId,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);

      await _progressCollection.doc(progressId).update({
        'completedQuizIds': FieldValue.arrayRemove([quizId]),
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to mark quiz as uncompleted: $e');
    }
  }

  @override
  Future<void> updateProgressPercentage({
    required String userId,
    required String courseId,
    required int totalItems,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);
      final doc = await _progressCollection.doc(progressId).get();

      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final completedVideos = List<String>.from(
        data['completedVideoIds'] ?? [],
      );
      final completedQuizzes = List<String>.from(
        data['completedQuizIds'] ?? [],
      );

      final completedCount = completedVideos.length + completedQuizzes.length;
      final percentage = totalItems > 0
          ? (completedCount / totalItems) * 100
          : 0.0;

      await _progressCollection.doc(progressId).update({
        'progressPercentage': percentage,
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update progress percentage: $e');
    }
  }

  @override
  Future<List<StudentProgressModel>> getUserAllProgress({
    required String userId,
  }) async {
    try {
      final querySnapshot = await _progressCollection
          .where('userId', isEqualTo: userId)
          .orderBy('lastAccessedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => StudentProgressModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user all progress: $e');
    }
  }

  @override
  Future<StudentProgressModel> initializeProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);
      final now = DateTime.now();

      final progressData = {
        'userId': userId,
        'courseId': courseId,
        'completedVideoIds': [],
        'completedQuizIds': [],
        'lastAccessedAt': Timestamp.fromDate(now),
        'progressPercentage': 0.0,
        'createdAt': Timestamp.fromDate(now),
      };

      await _progressCollection.doc(progressId).set(progressData);

      final doc = await _progressCollection.doc(progressId).get();
      return StudentProgressModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to initialize progress: $e');
    }
  }

  @override
  Future<void> resetProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      final progressId = _getProgressId(userId, courseId);

      await _progressCollection.doc(progressId).update({
        'completedVideoIds': [],
        'completedQuizIds': [],
        'progressPercentage': 0.0,
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reset progress: $e');
    }
  }
}
