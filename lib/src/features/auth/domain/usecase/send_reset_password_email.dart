import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmail {
  final AuthRepository repository;

  SendPasswordResetEmail(this.repository);

  Future<Either<Failure, void>> call({
    required SendPasswordResetParams params,
  }) {
    return repository.sendPasswordResetEmail(email: params.email);
  }
}

class SendPasswordResetParams extends Equatable {
  final String email;

  const SendPasswordResetParams({required this.email});

  @override
  List<Object?> get props => [email];
}
