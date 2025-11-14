import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class StartConference {
  final LiveConferenceRepository repository;

  StartConference(this.repository);

  Future<Either<Failure, void>> call(String conferenceId) {
    return repository.startConference(conferenceId);
  }
}
