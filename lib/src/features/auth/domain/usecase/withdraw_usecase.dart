import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';
import 'package:teach_flix/src/features/auth/domain/repositories/auth_repository.dart';

class WithdrawParams extends Equatable {
  final double amount;

  const WithdrawParams({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class Withdraw {
  final AuthRepository repository;

  Withdraw({required this.repository});

  Future<Either<Failure, UserEntity>> call({required WithdrawParams params}) =>
      repository.withdraw(params: params);
}
