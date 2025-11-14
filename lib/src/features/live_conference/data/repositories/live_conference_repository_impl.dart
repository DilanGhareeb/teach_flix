import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/data/datasources/live_conference_firebase_datasource.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class LiveConferenceRepositoryImpl implements LiveConferenceRepository {
  final LiveConferenceFirebaseDataSource dataSource;

  LiveConferenceRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, LiveConference>> createConference({
    required String title,
    required String description,
    required String instructorId,
    required String instructorName,
    required double price,
    required DateTime scheduledStartTime,
    required int maxDuration,
    required int maxParticipants,
  }) {
    return dataSource.createConference(
      title: title,
      description: description,
      instructorId: instructorId,
      instructorName: instructorName,
      price: price,
      scheduledStartTime: scheduledStartTime,
      maxDuration: maxDuration,
      maxParticipants: maxParticipants,
    );
  }

  @override
  Future<Either<Failure, List<LiveConference>>> getAllActiveConferences() {
    return dataSource.getAllActiveConferences();
  }

  @override
  Stream<Either<Failure, List<LiveConference>>> watchActiveConferences() {
    return dataSource.watchActiveConferences();
  }

  @override
  Future<Either<Failure, LiveConference>> getConferenceById(
    String conferenceId,
  ) {
    return dataSource.getConferenceById(conferenceId);
  }

  @override
  Future<Either<Failure, void>> purchaseConferenceAccess({
    required String userId,
    required String conferenceId,
  }) {
    return dataSource.purchaseConferenceAccess(
      userId: userId,
      conferenceId: conferenceId,
    );
  }

  @override
  Future<Either<Failure, void>> joinConference({
    required String userId,
    required String conferenceId,
  }) {
    return dataSource.joinConference(
      userId: userId,
      conferenceId: conferenceId,
    );
  }

  @override
  Future<Either<Failure, void>> endConference(String conferenceId) {
    return dataSource.endConference(conferenceId);
  }

  @override
  Future<Either<Failure, bool>> hasUserPurchasedAccess({
    required String userId,
    required String conferenceId,
  }) {
    return dataSource.hasUserPurchasedAccess(
      userId: userId,
      conferenceId: conferenceId,
    );
  }

  @override
  Future<Either<Failure, void>> startConference(String conferenceId) {
    return dataSource.startConference(conferenceId);
  }
}
