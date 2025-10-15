import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class DepositParams extends Equatable {
  final double amount;

  const DepositParams({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class Deposit {
  final AuthRepository repository;

  Deposit({required this.repository});

  Future<Either<Failure, UserEntity>> call({required DepositParams params}) =>
      repository.deposit(params: params);
}
