import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class PurchaseConferenceAccess {
  final LiveConferenceRepository repository;

  PurchaseConferenceAccess(this.repository);

  Future<Either<Failure, void>> call(PurchaseConferenceParams params) async {
    return await repository.purchaseConferenceAccess(params: params);
  }
}

class PurchaseConferenceParams extends Equatable {
  final String userId;
  final String conferenceId;

  const PurchaseConferenceParams({
    required this.userId,
    required this.conferenceId,
  });

  @override
  List<Object?> get props => [userId, conferenceId];
}
