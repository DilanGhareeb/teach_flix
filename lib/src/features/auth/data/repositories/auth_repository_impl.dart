import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/features/auth/data/models/user_model.dart';
import 'package:teach_flix/src/features/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';
import 'package:teach_flix/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/deposit_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/withdraw_usecase.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDatasource authApiDatasource;

  AuthRepositoryImpl({required this.authApiDatasource});

  @override
  Stream<AuthSession> watchSession() {
    return authApiDatasource.watchSession();
  }

  @override
  Stream<Either<Failure, UserEntity>> watchUserById(String uid) {
    return authApiDatasource.watchUserById(uid: uid);
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final either = await authApiDatasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return either.fold(Left.new, (UserModel m) => Right(m));
  }

  @override
  Future<Either<Failure, UserEntity>> registerAccount({
    required RegisterParams params,
  }) async {
    final either = await authApiDatasource.registerAccount(params: params);
    return either.fold(Left.new, (UserModel m) => Right(m));
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) {
    return authApiDatasource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<Either<Failure, void>> signOut() => authApiDatasource.signOut();

  @override
  Future<Either<Failure, UserEntity>> updateUserInfo({
    required UpdateUserParams params,
  }) async {
    final either = await authApiDatasource.updateUserInfo(params: params);
    return either.fold(Left.new, (UserEntity m) => Right(m));
  }

  @override
  Future<Either<Failure, UserEntity>> deposit({
    required DepositParams params,
  }) async {
    final either = await authApiDatasource.deposit(params: params);
    return either.fold(Left.new, (UserEntity m) => Right(m));
  }

  @override
  Future<Either<Failure, UserEntity>> withdraw({
    required WithdrawParams params,
  }) async {
    final either = await authApiDatasource.withdraw(params: params);
    return either.fold(Left.new, (UserEntity m) => Right(m));
  }
}
