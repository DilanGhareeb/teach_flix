import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/data/models/live_conference_model.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/purchase_conference_access.dart';

abstract class LiveConferenceFirebaseDataSource {
  Future<Either<Failure, LiveConferenceModel>> createConference({
    required String title,
    required String description,
    required String instructorId,
    required String instructorName,
    required double price,
    required DateTime scheduledStartTime,
    required int maxDuration,
    required int maxParticipants,
  });

  Future<Either<Failure, List<LiveConferenceModel>>> getAllActiveConferences();

  Stream<Either<Failure, List<LiveConferenceModel>>> watchActiveConferences();

  Future<Either<Failure, LiveConferenceModel>> getConferenceById(
    String conferenceId,
  );

  Future<Either<Failure, void>> purchaseConferenceAccess({
    required PurchaseConferenceParams params,
  });

  Future<Either<Failure, void>> joinConference({
    required String userId,
    required String conferenceId,
  });

  Future<Either<Failure, void>> endConference(String conferenceId);

  Future<Either<Failure, bool>> hasUserPurchasedAccess({
    required String userId,
    required String conferenceId,
  });

  Future<Either<Failure, void>> startConference(String conferenceId);
  Future<Either<Failure, void>> deleteConference(String conferenceId);
}

class LiveConferenceFirebaseDataSourceImpl
    implements LiveConferenceFirebaseDataSource {
  final FirebaseFirestore _firestore;

  LiveConferenceFirebaseDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> startConference(String conferenceId) async {
    try {
      await _firestore.collection('live_conferences').doc(conferenceId).update({
        'status': 'live',
        'actualStartTime': Timestamp.now(),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, LiveConferenceModel>> createConference({
    required String title,
    required String description,
    required String instructorId,
    required String instructorName,
    required double price,
    required DateTime scheduledStartTime,
    required int maxDuration,
    required int maxParticipants,
  }) async {
    try {
      return await _firestore
          .runTransaction<Either<Failure, LiveConferenceModel>>((
            transaction,
          ) async {
            final docRef = _firestore.collection('live_conferences').doc();
            final roomId = 'room_${docRef.id}';

            final conferenceModel = LiveConferenceModel(
              id: docRef.id,
              title: title,
              description: description,
              instructorId: instructorId,
              instructorName: instructorName,
              price: price,
              scheduledStartTime: scheduledStartTime,
              maxDuration: maxDuration,
              maxParticipants: maxParticipants,
              currentParticipants: 0,
              status: 'scheduled',
              roomId: roomId,
              enrolledStudentIds: [],
              createdAt: DateTime.now(),
            );

            transaction.set(docRef, conferenceModel.toFirestore());

            return Right(conferenceModel);
          });
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<LiveConferenceModel>>>
  getAllActiveConferences() async {
    try {
      final querySnapshot = await _firestore
          .collection('live_conferences')
          .where('status', whereIn: ['scheduled', 'live'])
          .orderBy('scheduledStartTime', descending: false)
          .get();

      final conferences = querySnapshot.docs
          .map((doc) => LiveConferenceModel.fromFirestore(doc))
          .toList();

      return Right(conferences);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Stream<Either<Failure, List<LiveConferenceModel>>> watchActiveConferences() {
    return _firestore
        .collection('live_conferences')
        .where('status', whereIn: ['scheduled', 'live'])
        .orderBy('scheduledStartTime', descending: false)
        .snapshots()
        .map((snapshot) {
          try {
            final conferences = snapshot.docs
                .map((doc) => LiveConferenceModel.fromFirestore(doc))
                .toList();
            return Right<Failure, List<LiveConferenceModel>>(conferences);
          } catch (e) {
            if (e is FirebaseException) {
              return Left<Failure, List<LiveConferenceModel>>(
                FirestoreFailure.fromFirebaseCode(e.code),
              );
            }
            return const Left<Failure, List<LiveConferenceModel>>(
              UnknownFailure(),
            );
          }
        });
  }

  @override
  Future<Either<Failure, LiveConferenceModel>> getConferenceById(
    String conferenceId,
  ) async {
    try {
      final docSnapshot = await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .get();

      if (!docSnapshot.exists) {
        return const Left(NotFoundFailure());
      }

      final conference = LiveConferenceModel.fromFirestore(docSnapshot);

      return Right(conference);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> purchaseConferenceAccess({
    required PurchaseConferenceParams params,
  }) async {
    try {
      // 1. Get conference details - FIXED: Use correct collection name
      final conferenceDoc = await _firestore
          .collection('live_conferences')
          .doc(params.conferenceId)
          .get();

      if (!conferenceDoc.exists) {
        return const Left(NotFoundFailure());
      }

      final conferenceData = conferenceDoc.data()!;
      final price = (conferenceData['price'] as num).toDouble();
      final instructorId = conferenceData['instructorId'] as String;
      final conferenceTitle = conferenceData['title'] as String;

      // Check if already enrolled
      final enrolledStudents = List<String>.from(
        conferenceData['enrolledStudentIds'] ?? [],
      );

      if (enrolledStudents.contains(params.userId)) {
        // User already has access - return success
        return const Right(null);
      }

      // 2. Get user details
      final userDoc = await _firestore
          .collection('users')
          .doc(params.userId)
          .get();

      if (!userDoc.exists) {
        return const Left(NotFoundFailure());
      }

      final userData = userDoc.data()!;
      final currentBalance = (userData['balance'] as num?)?.toDouble() ?? 0.0;
      final userName = userData['name'] as String? ?? 'Unknown';

      // 3. Check balance
      if (currentBalance < price) {
        return const Left(InsufficientBalanceFailure());
      }

      // 4. Use Firestore transaction to ensure atomicity
      await _firestore.runTransaction((transaction) async {
        // Re-check conference in transaction
        final conferenceSnapshot = await transaction.get(
          _firestore.collection('live_conferences').doc(params.conferenceId),
        );

        if (!conferenceSnapshot.exists) {
          throw Exception('Conference not found');
        }

        final currentEnrolled = List<String>.from(
          conferenceSnapshot.data()!['enrolledStudentIds'] ?? [],
        );

        // Double-check not already enrolled
        if (currentEnrolled.contains(params.userId)) {
          return; // Already enrolled, skip transaction
        }

        // Re-check user balance in transaction
        final userSnapshot = await transaction.get(
          _firestore.collection('users').doc(params.userId),
        );

        if (!userSnapshot.exists) {
          throw Exception('User not found');
        }

        final userBalance =
            (userSnapshot.data()!['balance'] as num?)?.toDouble() ?? 0.0;

        if (userBalance < price) {
          throw Exception('Insufficient balance');
        }

        // Deduct from user balance
        transaction.update(_firestore.collection('users').doc(params.userId), {
          'balance': FieldValue.increment(-price),
        });

        // Add to instructor balance (50% commission)
        transaction.update(_firestore.collection('users').doc(instructorId), {
          'balance': FieldValue.increment(price * 0.50),
        });

        // Add user to enrolled students - FIXED: Use correct collection name
        transaction.update(
          _firestore.collection('live_conferences').doc(params.conferenceId),
          {
            'enrolledStudentIds': FieldValue.arrayUnion([params.userId]),
          },
        );

        // Create transaction record for instructor stats
        final transactionRef = _firestore.collection('transactions').doc();
        transaction.set(transactionRef, {
          'id': transactionRef.id,
          'type': 'conference_purchase',
          'userId': params.userId,
          'userName': userName,
          'instructorId': instructorId,
          'conferenceId': params.conferenceId,
          'conferenceTitle': conferenceTitle,
          'amount': price,
          'platformFee': price * 0.50, // 50% platform fee
          'instructorProfit': price * 0.50, // 50% to instructor
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'completed',
        });
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      // Log the actual error for debugging
      print('FirebaseException during purchase: ${e.code} - ${e.message}');
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      // Log unexpected errors
      print('Unexpected error during purchase: $e');
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> joinConference({
    required String userId,
    required String conferenceId,
  }) async {
    try {
      return await _firestore.runTransaction<Either<Failure, void>>((
        transaction,
      ) async {
        final conferenceDoc = await transaction.get(
          _firestore.collection('live_conferences').doc(conferenceId),
        );

        if (!conferenceDoc.exists) {
          return const Left(NotFoundFailure());
        }

        final conferenceData = conferenceDoc.data()!;
        final status = conferenceData['status'] as String;
        final instructorId = conferenceData['instructorId'] as String;
        final maxParticipants = conferenceData['maxParticipants'] as int;
        final currentParticipants =
            conferenceData['currentParticipants'] as int;
        final actualStartTime = conferenceData['actualStartTime'] as Timestamp?;
        final price = (conferenceData['price'] as num?)?.toDouble() ?? 0.0;

        // Check if conference is live
        if (status != 'live') {
          return const Left(ConferenceNotLiveFailure());
        }

        // Check if user is instructor (instructors can always join)
        final isInstructor = userId == instructorId;

        if (!isInstructor) {
          // For paid conferences, check if user has purchased access
          if (price > 0) {
            final enrolledStudents = List<String>.from(
              conferenceData['enrolledStudentIds'] ?? [],
            );

            if (!enrolledStudents.contains(userId)) {
              return const Left(AccessNotPurchasedFailure());
            }
          }

          // Check join time limit (10 minutes)
          if (actualStartTime != null) {
            final startTime = actualStartTime.toDate();
            final now = DateTime.now();
            final elapsed = now.difference(startTime).inMinutes;

            if (elapsed > 10) {
              return const Left(JoinTimeLimitExceededFailure());
            }
          }

          // Check if conference is full
          if (currentParticipants >= maxParticipants) {
            return const Left(ConferenceFullFailure());
          }
        }

        // Update participant count
        transaction.update(
          _firestore.collection('live_conferences').doc(conferenceId),
          {'currentParticipants': FieldValue.increment(1)},
        );

        return const Right(null);
      });
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> endConference(String conferenceId) async {
    try {
      await _firestore.collection('live_conferences').doc(conferenceId).update({
        'status': 'ended',
        'endTime': Timestamp.now(),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteConference(String conferenceId) async {
    try {
      await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserPurchasedAccess({
    required String userId,
    required String conferenceId,
  }) async {
    try {
      // Check enrolledStudentIds in the conference document
      final conferenceDoc = await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .get();

      if (!conferenceDoc.exists) {
        return const Left(NotFoundFailure());
      }

      final enrolledStudents = List<String>.from(
        conferenceDoc.data()!['enrolledStudentIds'] ?? [],
      );

      return Right(enrolledStudents.contains(userId));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
