import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';

abstract class LiveConferenceRepository {
  Future<Either<Failure, LiveConference>> createConference({
    required String title,
    required String description,
    required String instructorId,
    required String instructorName,
    required double price,
    required DateTime scheduledStartTime,
    required int maxDuration,
    required int maxParticipants,
  });

  Future<Either<Failure, List<LiveConference>>> getAllActiveConferences();

  Stream<Either<Failure, List<LiveConference>>> watchActiveConferences();

  Future<Either<Failure, LiveConference>> getConferenceById(
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
