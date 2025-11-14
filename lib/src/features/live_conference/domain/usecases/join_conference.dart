import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class JoinConference {
  final LiveConferenceRepository repository;

  JoinConference(this.repository);

  Future<Either<Failure, void>> call(JoinConferenceParams params) {
    return repository.joinConference(
      userId: params.userId,
      conferenceId: params.conferenceId,
    );
  }
}

class JoinConferenceParams extends Equatable {
  final String userId;
  final String conferenceId;

  const JoinConferenceParams({
    required this.userId,
    required this.conferenceId,
  });

  @override
  List<Object?> get props => [userId, conferenceId];
}
