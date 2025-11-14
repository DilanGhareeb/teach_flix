import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class DeleteConference {
  final LiveConferenceRepository repository;

  DeleteConference(this.repository);

  Future<Either<Failure, void>> call(String conferenceId) async {
    return await repository.deleteConference(conferenceId);
  }
}
