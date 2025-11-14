import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class WatchActiveConferences {
  final LiveConferenceRepository repository;

  WatchActiveConferences(this.repository);

  Stream<Either<Failure, List<LiveConference>>> call() {
    return repository.watchActiveConferences();
  }
}
