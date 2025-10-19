import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/deposit_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/withdraw_usecase.dart';

abstract class AuthRepository {
  Stream<AuthSession> watchSession();
  Stream<Either<Failure, UserEntity>> watchUserById(String uid);
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity>> registerAccount({
    required RegisterParams params,
  });
  Future<Either<Failure, UserEntity>> updateUserInfo({
    required UpdateUserParams params,
  });
  Future<Either<Failure, UserEntity>> deposit({required DepositParams params});
  Future<Either<Failure, UserEntity>> withdraw({
    required WithdrawParams params,
  });
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});
  Future<Either<Failure, void>> signOut();
}
