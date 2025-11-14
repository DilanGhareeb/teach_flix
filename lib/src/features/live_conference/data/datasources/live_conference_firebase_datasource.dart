import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/data/models/live_conference_model.dart';

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
    required String userId,
    required String conferenceId,
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
    required String userId,
    required String conferenceId,
  }) async {
    try {
      return await _firestore.runTransaction<Either<Failure, void>>((
        transaction,
      ) async {
        // Get conference
        final conferenceDoc = await transaction.get(
          _firestore.collection('live_conferences').doc(conferenceId),
        );

        if (!conferenceDoc.exists) {
          return const Left(NotFoundFailure());
        }

        final conferenceData = conferenceDoc.data()!;
        final conferencePrice = (conferenceData['price'] as num).toDouble();
        final instructorId = conferenceData['instructorId'] as String;

        // Check if user is the instructor
        if (userId == instructorId) {
          return const Left(InstructorCannotPurchaseOwnCourseFailure());
        }

        // Check if already purchased
        final accessQuery = await _firestore
            .collection('conference_access')
            .where('userId', isEqualTo: userId)
            .where('conferenceId', isEqualTo: conferenceId)
            .get();

        if (accessQuery.docs.isNotEmpty) {
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
        if (currentBalance < conferencePrice) {
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

        // Calculate instructor's share (50% of conference price)
        final instructorProfit = conferencePrice * 0.5;

        // Deduct balance from user
        transaction.update(_firestore.collection('users').doc(userId), {
          'balance': currentBalance - conferencePrice,
        });

        // Add profit to instructor's balance
        transaction.update(_firestore.collection('users').doc(instructorId), {
          'balance': currentInstructorBalance + instructorProfit,
        });

        // Add access record
        transaction.set(_firestore.collection('conference_access').doc(), {
          'userId': userId,
          'conferenceId': conferenceId,
          'purchasedAt': Timestamp.now(),
          'instructorProfit': instructorProfit,
          'conferencePriceAtPurchase': conferencePrice,
        });

        // Add transaction record
        transaction.set(_firestore.collection('transactions').doc(), {
          'userId': userId,
          'conferenceId': conferenceId,
          'instructorId': instructorId,
          'amount': conferencePrice,
          'instructorProfit': instructorProfit,
          'platformProfit': conferencePrice - instructorProfit,
          'type': 'conference_purchase',
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

        // Check if conference is live
        if (status != 'live') {
          return const Left(ConferenceNotLiveFailure());
        }

        // Check if user is instructor (instructors can always join)
        final isInstructor = userId == instructorId;

        if (!isInstructor) {
          // Check if user has purchased access
          final accessQuery = await _firestore
              .collection('conference_access')
              .where('userId', isEqualTo: userId)
              .where('conferenceId', isEqualTo: conferenceId)
              .get();

          if (accessQuery.docs.isEmpty) {
            return const Left(AccessNotPurchasedFailure());
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

        // Update participant count and add to enrolled list
        final enrolledStudentIds = List<String>.from(
          conferenceData['enrolledStudentIds'] ?? [],
        );

        if (!enrolledStudentIds.contains(userId)) {
          enrolledStudentIds.add(userId);

          transaction.update(
            _firestore.collection('live_conferences').doc(conferenceId),
            {
              'currentParticipants': currentParticipants + 1,
              'enrolledStudentIds': enrolledStudentIds,
            },
          );
        }

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
      final querySnapshot = await _firestore
          .collection('conference_access')
          .where('userId', isEqualTo: userId)
          .where('conferenceId', isEqualTo: conferenceId)
          .get();

      return Right(querySnapshot.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseCode(e.code));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
