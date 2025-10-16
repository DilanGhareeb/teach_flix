import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/instructor_stats/data/models/course_stats_model.dart';
import 'package:teach_flix/src/features/instructor_stats/data/models/instructor_stats_model.dart';
import 'package:teach_flix/src/features/instructor_stats/data/models/transaction_model.dart';

abstract class InstructorStatsFirebaseDataSource {
  Future<Either<Failure, InstructorStatsModel>> getInstructorStats(
    String instructorId,
  );

  Future<Either<Failure, CourseStatsModel>> getCourseStats(String courseId);

  Future<Either<Failure, List<TransactionModel>>> getInstructorTransactions(
    String instructorId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  Future<Either<Failure, List<TransactionModel>>> getCourseTransactions(
    String courseId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  Stream<Either<Failure, InstructorStatsModel>> watchInstructorStats(
    String instructorId,
  );
}

class InstructorStatsFirebaseDataSourceImpl
    implements InstructorStatsFirebaseDataSource {
  final FirebaseFirestore _firestore;

  InstructorStatsFirebaseDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, InstructorStatsModel>> getInstructorStats(
    String instructorId,
  ) async {
    try {
      // Get all courses by instructor
      final coursesSnapshot = await _firestore
          .collection('courses')
          .where('instructorId', isEqualTo: instructorId)
          .get();

      if (coursesSnapshot.docs.isEmpty) {
        return Right(_createEmptyStats(instructorId));
      }

      final courseIds = coursesSnapshot.docs.map((doc) => doc.id).toList();

      // Get all transactions for this instructor
      final transactionsSnapshot = await _firestore
          .collection('transactions')
          .where('instructorId', isEqualTo: instructorId)
          .where('type', isEqualTo: 'course_purchase')
          .get();

      final transactions = transactionsSnapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();

      // Calculate time-based profits
      final profitData = _calculateProfits(transactions);

      // Calculate total unique students
      final enrollmentsSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', whereIn: courseIds)
          .where('isInstructor', isEqualTo: false)
          .get();

      final uniqueStudents = enrollmentsSnapshot.docs
          .map((doc) => doc.data()['userId'] as String)
          .toSet()
          .length;

      // Build course stats list
      final courseStatsList = await _buildCourseStatsList(
        coursesSnapshot.docs,
        transactions,
      );

      return Right(
        InstructorStatsModel(
          instructorId: instructorId,
          totalCourses: coursesSnapshot.docs.length,
          totalStudents: uniqueStudents,
          todayProfit: profitData['today']!,
          monthProfit: profitData['month']!,
          yearProfit: profitData['year']!,
          totalProfit: profitData['total']!,
          courseStats: courseStatsList,
          lastUpdated: DateTime.now(),
        ),
      );
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CourseStatsModel>> getCourseStats(
    String courseId,
  ) async {
    try {
      final courseDoc = await _firestore
          .collection('courses')
          .doc(courseId)
          .get();

      if (!courseDoc.exists) {
        return const Left(NotFoundFailure());
      }

      final courseData = courseDoc.data()!;

      // Get transactions for this course
      final transactionsSnapshot = await _firestore
          .collection('transactions')
          .where('courseId', isEqualTo: courseId)
          .where('type', isEqualTo: 'course_purchase')
          .get();

      final totalRevenue = transactionsSnapshot.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['instructorProfit'] as num).toDouble(),
      );

      // Calculate average rating
      final ratingData = _calculateAverageRating(courseData);

      return Right(
        CourseStatsModel(
          courseId: courseId,
          courseTitle: courseData['title'] as String,
          imageUrl: courseData['imageUrl'] as String?,
          studentsEnrolled:
              (courseData['studentsEnrolled'] as num?)?.toInt() ?? 0,
          coursePrice: (courseData['price'] as num).toDouble(),
          totalRevenue: totalRevenue,
          averageRating: ratingData['average']!,
          totalRatings: ratingData['total']!.toInt(),
          createdAt: (courseData['createAt'] as Timestamp).toDate(),
        ),
      );
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getInstructorTransactions(
    String instructorId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('transactions')
          .where('instructorId', isEqualTo: instructorId)
          .orderBy('createdAt', descending: true);

      query = _applyDateFilters(query, startDate, endDate);

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      final transactions = snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();

      return Right(transactions);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getCourseTransactions(
    String courseId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('transactions')
          .where('courseId', isEqualTo: courseId)
          .orderBy('createdAt', descending: true);

      query = _applyDateFilters(query, startDate, endDate);

      final snapshot = await query.get();
      final transactions = snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();

      return Right(transactions);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Stream<Either<Failure, InstructorStatsModel>> watchInstructorStats(
    String instructorId,
  ) {
    late StreamController<Either<Failure, InstructorStatsModel>> controller;
    StreamSubscription? coursesSub;
    StreamSubscription? transactionsSub;
    bool isCalculating = false;
    bool isCancelled = false;

    controller =
        StreamController<Either<Failure, InstructorStatsModel>>.broadcast(
          onCancel: () async {
            isCancelled = true;

            // Cancel subscriptions
            await coursesSub?.cancel();
            await transactionsSub?.cancel();

            coursesSub = null;
            transactionsSub = null;

            // Close controller if not already closed
            if (!controller.isClosed) {
              await controller.close();
            }
          },
        );

    final coursesStream = _firestore
        .collection('courses')
        .where('instructorId', isEqualTo: instructorId)
        .snapshots();

    final transactionsStream = _firestore
        .collection('transactions')
        .where('instructorId', isEqualTo: instructorId)
        .snapshots();

    Future<void> recalculateStats() async {
      // Check if cancelled or already calculating
      if (isCancelled || controller.isClosed || isCalculating) return;

      isCalculating = true;
      try {
        final result = await getInstructorStats(instructorId);

        // Check again after async operation
        if (!isCancelled && !controller.isClosed) {
          controller.add(result);
        }
      } catch (e) {
        if (!isCancelled && !controller.isClosed) {
          controller.add(const Left(UnknownFailure()));
        }
      } finally {
        isCalculating = false;
      }
    }

    coursesSub = coursesStream.listen(
      (_) {
        if (!isCancelled && !controller.isClosed) {
          recalculateStats();
        }
      },
      onError: (error) {
        if (!isCancelled && !controller.isClosed) {
          if (error is FirebaseException) {
            controller.add(Left(FirestoreFailure.fromFirebaseCode(error.code)));
          } else {
            controller.add(const Left(UnknownFailure()));
          }
        }
      },
      cancelOnError: false,
    );

    transactionsSub = transactionsStream.listen(
      (_) {
        if (!isCancelled && !controller.isClosed) {
          recalculateStats();
        }
      },
      onError: (error) {
        if (!isCancelled && !controller.isClosed) {
          if (error is FirebaseException) {
            controller.add(Left(FirestoreFailure.fromFirebaseCode(error.code)));
          } else {
            controller.add(const Left(UnknownFailure()));
          }
        }
      },
      cancelOnError: false,
    );

    return controller.stream;
  }

  // ========== PRIVATE HELPER METHODS ==========

  InstructorStatsModel _createEmptyStats(String instructorId) {
    return InstructorStatsModel(
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

  Map<String, double> _calculateProfits(List<TransactionModel> transactions) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final monthStart = DateTime(now.year, now.month, 1);
    final yearStart = DateTime(now.year, 1, 1);

    double todayProfit = 0.0;
    double monthProfit = 0.0;
    double yearProfit = 0.0;
    double totalProfit = 0.0;

    for (final transaction in transactions) {
      final profit = transaction.instructorProfit;
      totalProfit += profit;

      if (transaction.createdAt.isAfter(todayStart)) {
        todayProfit += profit;
      }
      if (transaction.createdAt.isAfter(monthStart)) {
        monthProfit += profit;
      }
      if (transaction.createdAt.isAfter(yearStart)) {
        yearProfit += profit;
      }
    }

    return {
      'today': todayProfit,
      'month': monthProfit,
      'year': yearProfit,
      'total': totalProfit,
    };
  }

  Map<String, double> _calculateAverageRating(Map<String, dynamic> courseData) {
    final ratings = (courseData['ratings'] as List<dynamic>?) ?? [];

    if (ratings.isEmpty) {
      return {'average': 0.0, 'total': 0.0};
    }

    final totalRating = ratings.fold<double>(
      0.0,
      (sum, rating) => sum + (rating['rating'] as num).toDouble(),
    );

    return {
      'average': totalRating / ratings.length,
      'total': ratings.length.toDouble(),
    };
  }

  Future<List<CourseStatsModel>> _buildCourseStatsList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> courseDocs,
    List<TransactionModel> allTransactions,
  ) async {
    final courseStatsList = <CourseStatsModel>[];

    for (final courseDoc in courseDocs) {
      final courseData = courseDoc.data();
      final courseId = courseDoc.id;

      // Filter transactions for this course
      final courseTransactions = allTransactions
          .where((t) => t.courseId == courseId)
          .toList();

      final courseRevenue = courseTransactions.fold<double>(
        0.0,
        (sum, t) => sum + t.instructorProfit,
      );

      // Calculate rating
      final ratingData = _calculateAverageRating(courseData);

      courseStatsList.add(
        CourseStatsModel(
          courseId: courseId,
          courseTitle: courseData['title'] as String,
          imageUrl: courseData['imageUrl'] as String?,
          studentsEnrolled:
              (courseData['studentsEnrolled'] as num?)?.toInt() ?? 0,
          coursePrice: (courseData['price'] as num).toDouble(),
          totalRevenue: courseRevenue,
          averageRating: ratingData['average']!,
          totalRatings: ratingData['total']!.toInt(),
          createdAt: (courseData['createAt'] as Timestamp).toDate(),
        ),
      );
    }

    return courseStatsList;
  }

  Query<Map<String, dynamic>> _applyDateFilters(
    Query<Map<String, dynamic>> query,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    if (startDate != null) {
      query = query.where(
        'createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'createdAt',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    return query;
  }
}
