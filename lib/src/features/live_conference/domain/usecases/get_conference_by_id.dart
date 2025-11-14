import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class GetConferenceById {
  final LiveConferenceRepository repository;

  GetConferenceById(this.repository);

  Future<Either<Failure, LiveConference>> call(String conferenceId) {
    return repository.getConferenceById(conferenceId);
  }
}
