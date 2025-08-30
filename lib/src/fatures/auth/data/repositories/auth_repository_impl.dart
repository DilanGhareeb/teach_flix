import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/fatures/auth/data/models/user_model.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';

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
  Future<Either<Failure, void>> signOut() => authApiDatasource.signOut();
}
