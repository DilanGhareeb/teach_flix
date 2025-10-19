import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/data/models/course_model.dart';
import 'package:teach_flix/src/features/courses/data/models/course_rating_model.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_rating_entity.dart';

abstract class CourseFirebaseDataSource {
  Future<Either<Failure, List<CourseModel>>> getAllCourses();
  Future<Either<Failure, CourseModel>> getCourseById(String id);
  Future<Either<Failure, List<CourseModel>>> getCoursesByCategory(
    String category,
  );
  Future<Either<Failure, List<CourseModel>>> getCoursesByInstructor(
    String instructorId,
  );
  Future<Either<Failure, List<CourseModel>>> getTopRatedCourses({
    int limit = 3,
  });
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
  Future<Either<Failure, String>> uploadImage(
    File imageFile, {
    void Function(double progress)? onProgress,
  });
  Future<Either<Failure, void>> deleteImage(String imageUrl);
  Future<Either<Failure, void>> addRating({
    required String userId,
    required String courseId,
    required double rating,
    required String comment,
  });
  Future<Either<Failure, void>> updateRating({
    required String ratingId,
    required double rating,
    required String comment,
  });
  Future<Either<Failure, void>> deleteRating(String ratingId);
  Future<Either<Failure, CourseRatingModel?>> getUserRatingForCourse({
    required String userId,
    required String courseId,
  });
}

class CourseFirebaseDataSourceImpl implements CourseFirebaseDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CourseFirebaseDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<Either<Failure, List<CourseModel>>> getAllCourses() async {
    try {
      final querySnapshot = await _firestore.collection('courses').get();

      final courses = await Future.wait(
        querySnapshot.docs
            .map((doc) => CourseModel.fromFirestore(doc, _firestore))
            .toList(),
      );

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

      final course = await CourseModel.fromFirestore(docSnapshot, _firestore);

      return Right(course);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> getTopRatedCourses({
    int limit = 3,
  }) async {
    try {
      // Get all courses
      final coursesSnapshot = await _firestore.collection('courses').get();

      if (coursesSnapshot.docs.isEmpty) {
        return const Right([]);
      }

      // Create list to store courses with their ratings
      final List<Map<String, dynamic>> coursesWithRatings = [];

      for (final courseDoc in coursesSnapshot.docs) {
        final courseData = courseDoc.data();

        // Get ratings for this course from the ratings collection
        final ratingsSnapshot = await _firestore
            .collection('ratings')
            .where('courseId', isEqualTo: courseDoc.id)
            .get();

        double averageRating = 0.0;
        int totalRatings = ratingsSnapshot.docs.length;

        if (totalRatings > 0) {
          final totalRating = ratingsSnapshot.docs.fold<double>(
            0.0,
            (sum, doc) => sum + (doc.data()['rating'] as num).toDouble(),
          );
          averageRating = totalRating / totalRatings;
        }

        // Only include courses with at least 1 rating
        if (totalRatings > 0) {
          coursesWithRatings.add({
            'doc': courseDoc,
            'averageRating': averageRating,
            'totalRatings': totalRatings,
          });
        }
      }

      // Sort by average rating (descending), then by total ratings (descending)
      coursesWithRatings.sort((a, b) {
        final ratingComparison = (b['averageRating'] as double).compareTo(
          a['averageRating'] as double,
        );

        if (ratingComparison != 0) {
          return ratingComparison;
        }

        // If ratings are equal, sort by number of ratings
        return (b['totalRatings'] as int).compareTo(a['totalRatings'] as int);
      });

      // Take top N courses
      final topCourses = coursesWithRatings.take(limit).toList();

      // Convert to CourseModel
      final courses = await Future.wait(
        topCourses.map((item) async {
          final doc =
              item['doc'] as QueryDocumentSnapshot<Map<String, dynamic>>;
          return CourseModel.fromFirestore(doc, _firestore);
        }),
      );

      return Right(courses);
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

      final courses = await Future.wait(
        querySnapshot.docs
            .map((doc) => CourseModel.fromFirestore(doc, _firestore))
            .toList(),
      );

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

      final courses = await Future.wait(
        querySnapshot.docs
            .map((doc) => CourseModel.fromFirestore(doc, _firestore))
            .toList(),
      );

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

      final courses = await Future.wait(
        coursesSnapshot.docs
            .map((doc) => CourseModel.fromFirestore(doc, _firestore))
            .toList(),
      );

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
          studentsEnrolled: 1, // Start with 1 (the instructor)
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
          'instructorProfit': 0.0,
          'isInstructor': true,
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
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      final lowerQuery = query.toLowerCase().trim();
      final querySnapshot = await _firestore.collection('courses').get();

      final allCourses = await Future.wait(
        querySnapshot.docs
            .map((doc) => CourseModel.fromFirestore(doc, _firestore))
            .toList(),
      );

      final courses = allCourses.where((course) {
        final titleMatch = course.title.toLowerCase().contains(lowerQuery);
        final descriptionMatch = course.description.toLowerCase().contains(
          lowerQuery,
        );
        final categoryMatch = course.category.toLowerCase().contains(
          lowerQuery,
        );
        return titleMatch || descriptionMatch || categoryMatch;
      }).toList();

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
      return await _firestore.runTransaction<Either<Failure, void>>((
        transaction,
      ) async {
        // Check if already enrolled
        final existingEnrollment = await _firestore
            .collection('enrollments')
            .where('userId', isEqualTo: userId)
            .where('courseId', isEqualTo: courseId)
            .get();

        if (existingEnrollment.docs.isNotEmpty) {
          return const Left(AlreadyEnrolledFailure());
        }

        final courseDoc = await transaction.get(
          _firestore.collection('courses').doc(courseId),
        );

        if (!courseDoc.exists) {
          return const Left(NotFoundFailure());
        }

        final courseData = courseDoc.data()!;
        final coursePrice = (courseData['price'] as num).toDouble();
        final instructorId = courseData['instructorId'] as String;
        final currentStudentsEnrolled =
            (courseData['studentsEnrolled'] as num?)?.toInt() ?? 0;

        final isInstructor = userId == instructorId;

        // Increment students enrolled count
        transaction.update(_firestore.collection('courses').doc(courseId), {
          'studentsEnrolled': currentStudentsEnrolled + 1,
        });

        final enrollmentRef = _firestore.collection('enrollments').doc();
        transaction.set(enrollmentRef, {
          'userId': userId,
          'courseId': courseId,
          'enrolledAt': Timestamp.now(),
          'isInstructor': isInstructor,
          'instructorProfit': 0.0,
          'coursePriceAtEnrollment': coursePrice,
        });

        transaction.set(_firestore.collection('transactions').doc(), {
          'userId': userId,
          'courseId': courseId,
          'instructorId': instructorId,
          'amount': 0.0,
          'instructorProfit': 0.0,
          'platformProfit': 0.0,
          'type': 'free_enrollment',
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
        final coursePrice = (courseData['price'] as num).toDouble();
        final instructorId = courseData['instructorId'] as String;
        final currentStudentsEnrolled =
            (courseData['studentsEnrolled'] as num?)?.toInt() ?? 0;

        // Check if user is the instructor
        if (userId == instructorId) {
          return const Left(InstructorCannotPurchaseOwnCourseFailure());
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

        // Get instructor's current balance
        final instructorDoc = await transaction.get(
          _firestore.collection('users').doc(instructorId),
        );
        if (!instructorDoc.exists) {
          return const Left(NotFoundFailure());
        }

        final currentInstructorBalance =
            (instructorDoc.data()!['balance'] as num).toDouble();

        // Calculate instructor's share (50% of course price)
        final instructorProfit = coursePrice * 0.5;

        // Deduct balance from user
        transaction.update(_firestore.collection('users').doc(userId), {
          'balance': currentBalance - coursePrice,
        });

        // Add profit to instructor's balance
        transaction.update(_firestore.collection('users').doc(instructorId), {
          'balance': currentInstructorBalance + instructorProfit,
        });

        // Increment students enrolled count
        transaction.update(_firestore.collection('courses').doc(courseId), {
          'studentsEnrolled': currentStudentsEnrolled + 1,
        });

        // Add enrollment with profit information
        transaction.set(_firestore.collection('enrollments').doc(), {
          'userId': userId,
          'courseId': courseId,
          'enrolledAt': Timestamp.now(),
          'isInstructor': false,
          'instructorProfit': instructorProfit,
          'coursePriceAtEnrollment': coursePrice,
        });

        // Add transaction record
        transaction.set(_firestore.collection('transactions').doc(), {
          'userId': userId,
          'courseId': courseId,
          'instructorId': instructorId,
          'amount': coursePrice,
          'instructorProfit': instructorProfit,
          'platformProfit': coursePrice - instructorProfit,
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
        .asyncMap((snapshot) async {
          try {
            final courses = await Future.wait(
              snapshot.docs
                  .map((doc) => CourseModel.fromFirestore(doc, _firestore))
                  .toList(),
            );
            return Right<Failure, List<CourseModel>>(courses);
          } catch (e) {
            if (e is FirebaseException) {
              return Left<Failure, List<CourseModel>>(
                FirestoreFailure.fromFirebaseCode(e.code),
              );
            }
            return const Left<Failure, List<CourseModel>>(UnknownFailure());
          }
        });
  }

  @override
  Future<Either<Failure, String>> uploadImage(
    File imageFile, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final fileName = 'course_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage
          .ref()
          .child('course_thumbnails')
          .child(fileName);

      final uploadTask = storageRef.putFile(imageFile);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      await uploadTask;
      final downloadUrl = await storageRef.getDownloadURL();

      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left(StorageFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(StorageFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addRating({
    required String userId,
    required String courseId,
    required double rating,
    required String comment,
  }) async {
    try {
      return await _firestore.runTransaction<Either<Failure, void>>((
        transaction,
      ) async {
        // Check if user is enrolled in the course
        final enrollmentQuery = await _firestore
            .collection('enrollments')
            .where('userId', isEqualTo: userId)
            .where('courseId', isEqualTo: courseId)
            .get();

        if (enrollmentQuery.docs.isEmpty) {
          return const Left(NotEnrolledFailure());
        }

        // Check if user already rated this course
        final existingRating = await _firestore
            .collection('ratings')
            .where('userId', isEqualTo: userId)
            .where('courseId', isEqualTo: courseId)
            .get();

        if (existingRating.docs.isNotEmpty) {
          return const Left(AlreadyRatedFailure());
        }

        // Validate rating value
        if (rating < 1.0 || rating > 5.0) {
          return const Left(InvalidRatingValueFailure());
        }

        // Get course document
        final courseDoc = await transaction.get(
          _firestore.collection('courses').doc(courseId),
        );

        if (!courseDoc.exists) {
          return const Left(NotFoundFailure());
        }

        final instructorId = courseDoc.data()!['instructorId'] as String;

        // Check if user is the instructor
        if (userId == instructorId) {
          return const Left(InstructorCannotRateOwnCourseFailure());
        }

        // Add the rating
        final ratingRef = _firestore.collection('ratings').doc();
        transaction.set(ratingRef, {
          'id': ratingRef.id,
          'userId': userId,
          'courseId': courseId,
          'rating': rating,
          'comment': comment,
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
  Future<Either<Failure, void>> updateRating({
    required String ratingId,
    required double rating,
    required String comment,
  }) async {
    try {
      // Validate rating value
      if (rating < 1.0 || rating > 5.0) {
        return const Left(InvalidRatingValueFailure());
      }

      final ratingDoc = await _firestore
          .collection('ratings')
          .doc(ratingId)
          .get();

      if (!ratingDoc.exists) {
        return const Left(NotFoundFailure());
      }

      await _firestore.collection('ratings').doc(ratingId).update({
        'rating': rating,
        'comment': comment,
        'updatedAt': Timestamp.now(),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRating(String ratingId) async {
    try {
      final ratingDoc = await _firestore
          .collection('ratings')
          .doc(ratingId)
          .get();

      if (!ratingDoc.exists) {
        return const Left(NotFoundFailure());
      }

      await _firestore.collection('ratings').doc(ratingId).delete();

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CourseRatingModel?>> getUserRatingForCourse({
    required String userId,
    required String courseId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Right(null);
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      final rating = CourseRatingModel(
        id: data['id'] as String,
        userId: data['userId'] as String,
        courseId: data['courseId'] as String,
        rating: (data['rating'] as num).toDouble(),
        comment: data['comment'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );

      return Right(rating);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
