import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/courses/data/models/course_model.dart';

abstract class CourseFirebaseDataSource {
  Future<Either<Failure, List<CourseModel>>> getAllCourses();
  Future<Either<Failure, CourseModel>> getCourseById(String id);
  Future<Either<Failure, List<CourseModel>>> getCoursesByCategory(
    String category,
  );
  Future<Either<Failure, List<CourseModel>>> getCoursesByInstructor(
    String instructorId,
  );
  Future<Either<Failure, List<CourseModel>>> getEnrolledCourses(String userId);
  Future<Either<Failure, CourseModel>> createCourse(CourseModel course);
  Future<Either<Failure, CourseModel>> updateCourse(CourseModel course);
  Future<Either<Failure, void>> deleteCourse(String id);
  Future<Either<Failure, List<CourseModel>>> searchCourses(String query);
  Future<Either<Failure, void>> enrollInCourse(String userId, String courseId);
  Future<Either<Failure, bool>> isEnrolledInCourse(
    String userId,
    String courseId,
  );
  Future<Either<Failure, void>> purchaseCourse(String userId, String courseId);
  Stream<Either<Failure, List<CourseModel>>> watchCoursesByInstructor(
    String instructorId,
  );
}

class CourseFirebaseDataSourceImpl implements CourseFirebaseDataSource {
  final FirebaseFirestore _firestore;

  CourseFirebaseDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<CourseModel>>> getAllCourses() async {
    try {
      final querySnapshot = await _firestore.collection('courses').get();
      final courses = querySnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();
      return Right(courses);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CourseModel>> getCourseById(String id) async {
    try {
      final docSnapshot = await _firestore.collection('courses').doc(id).get();

      if (!docSnapshot.exists) {
        return const Left(NotFoundFailure());
      }

      final course = CourseModel.fromFirestore(docSnapshot);
      return Right(course);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> getCoursesByCategory(
    String category,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('courses')
          .where('category', isEqualTo: category)
          .get();

      final courses = querySnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();
      return Right(courses);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> getCoursesByInstructor(
    String instructorId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('courses')
          .where('instructorId', isEqualTo: instructorId)
          .get();

      final courses = querySnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();
      return Right(courses);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> getEnrolledCourses(
    String userId,
  ) async {
    try {
      final enrollmentsSnapshot = await _firestore
          .collection('enrollments')
          .where('userId', isEqualTo: userId)
          .get();

      final courseIds = enrollmentsSnapshot.docs
          .map((doc) => doc.data()['courseId'] as String)
          .toList();

      if (courseIds.isEmpty) {
        return const Right([]);
      }

      final coursesSnapshot = await _firestore
          .collection('courses')
          .where(FieldPath.documentId, whereIn: courseIds)
          .get();

      final courses = coursesSnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();

      return Right(courses);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CourseModel>> createCourse(CourseModel course) async {
    try {
      return await _firestore.runTransaction<Either<Failure, CourseModel>>((
        transaction,
      ) async {
        final docRef = _firestore.collection('courses').doc();
        final courseWithId = CourseModel(
          id: docRef.id,
          title: course.title,
          description: course.description,
          imageUrl: course.imageUrl,
          previewVideoUrl: course.previewVideoUrl,
          category: course.category,
          price: course.price,
          instructorId: course.instructorId,
          createAt: DateTime.now(),
          ratings: course.ratings,
          chapters: course.chapters,
        );

        // Create the course
        transaction.set(docRef, courseWithId.toFirestore());

        // Automatically enroll the instructor in their own course
        final enrollmentRef = _firestore.collection('enrollments').doc();
        transaction.set(enrollmentRef, {
          'userId': course.instructorId,
          'courseId': docRef.id,
          'enrolledAt': Timestamp.now(),
          'isInstructor': true, // Mark as instructor enrollment
        });

        return Right(courseWithId);
      });
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CourseModel>> updateCourse(CourseModel course) async {
    try {
      await _firestore
          .collection('courses')
          .doc(course.id)
          .update(course.toFirestore());

      return Right(course);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(String id) async {
    try {
      // Delete the course and all related enrollments
      await _firestore.runTransaction((transaction) async {
        // Delete the course
        transaction.delete(_firestore.collection('courses').doc(id));

        // Get and delete all enrollments for this course
        final enrollmentsSnapshot = await _firestore
            .collection('enrollments')
            .where('courseId', isEqualTo: id)
            .get();

        for (final doc in enrollmentsSnapshot.docs) {
          transaction.delete(doc.reference);
        }
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> searchCourses(String query) async {
    try {
      // Convert query to lowercase for case-insensitive search
      final lowerQuery = query.toLowerCase();

      final querySnapshot = await _firestore
          .collection('courses')
          .where('titleLowercase', isGreaterThanOrEqualTo: lowerQuery)
          .where('titleLowercase', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .get();

      final courses = querySnapshot.docs
          .map((doc) => CourseModel.fromFirestore(doc))
          .toList();
      return Right(courses);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> enrollInCourse(
    String userId,
    String courseId,
  ) async {
    try {
      // Check if already enrolled
      final existingEnrollment = await _firestore
          .collection('enrollments')
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .get();

      if (existingEnrollment.docs.isNotEmpty) {
        return const Left(AlreadyEnrolledFailure());
      }

      await _firestore.collection('enrollments').add({
        'userId': userId,
        'courseId': courseId,
        'enrolledAt': Timestamp.now(),
        'isInstructor': false,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isEnrolledInCourse(
    String userId,
    String courseId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('enrollments')
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .get();

      return Right(querySnapshot.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> purchaseCourse(
    String userId,
    String courseId,
  ) async {
    try {
      return await _firestore.runTransaction<Either<Failure, void>>((
        transaction,
      ) async {
        // Get course
        final courseDoc = await transaction.get(
          _firestore.collection('courses').doc(courseId),
        );
        if (!courseDoc.exists) {
          return const Left(NotFoundFailure());
        }

        final courseData = courseDoc.data()!;
        final coursePrice = courseData['price'] as double;
        final instructorId = courseData['instructorId'] as String;

        // Check if user is the instructor (instructors don't pay for their own courses)
        if (userId == instructorId) {
          return const Left(InstructorCannotPurchaseOwnCourseFailure());
        }

        // Get user balance
        final userDoc = await transaction.get(
          _firestore.collection('users').doc(userId),
        );
        if (!userDoc.exists) {
          return const Left(NotFoundFailure());
        }

        final currentBalance = (userDoc.data()!['balance'] as num).toDouble();

        // Check if user has enough balance
        if (currentBalance < coursePrice) {
          return const Left(InsufficientBalanceFailure());
        }

        // Check if already enrolled
        final enrollmentQuery = await _firestore
            .collection('enrollments')
            .where('userId', isEqualTo: userId)
            .where('courseId', isEqualTo: courseId)
            .get();

        if (enrollmentQuery.docs.isNotEmpty) {
          return const Left(AlreadyEnrolledFailure());
        }

        // Deduct balance from user
        transaction.update(_firestore.collection('users').doc(userId), {
          'balance': currentBalance - coursePrice,
        });

        // Add enrollment
        transaction.set(_firestore.collection('enrollments').doc(), {
          'userId': userId,
          'courseId': courseId,
          'enrolledAt': Timestamp.now(),
          'isInstructor': false,
        });

        // Add transaction record
        transaction.set(_firestore.collection('transactions').doc(), {
          'userId': userId,
          'courseId': courseId,
          'instructorId': instructorId,
          'amount': coursePrice,
          'type': 'course_purchase',
          'createdAt': Timestamp.now(),
        });

        return const Right(null);
      });
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Stream<Either<Failure, List<CourseModel>>> watchCoursesByInstructor(
    String instructorId,
  ) {
    return _firestore
        .collection('courses')
        .where('instructorId', isEqualTo: instructorId)
        .snapshots()
        .transform(
          StreamTransformer.fromHandlers(
            handleData:
                (
                  QuerySnapshot<Map<String, dynamic>> snapshot,
                  EventSink<Either<Failure, List<CourseModel>>> sink,
                ) {
                  try {
                    final courses = snapshot.docs
                        .map((doc) => CourseModel.fromFirestore(doc))
                        .toList();
                    sink.add(Right(courses));
                  } catch (e) {
                    sink.add(const Left(UnknownFailure()));
                  }
                },
            handleError:
                (
                  error,
                  stackTrace,
                  EventSink<Either<Failure, List<CourseModel>>> sink,
                ) {
                  if (error is FirebaseException) {
                    sink.add(
                      Left(FirestoreFailure.fromFirebaseCode(error.code)),
                    );
                  } else {
                    sink.add(const Left(UnknownFailure()));
                  }
                },
          ),
        );
  }
}
