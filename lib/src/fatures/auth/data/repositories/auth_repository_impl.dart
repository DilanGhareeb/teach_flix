import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApiDatasource authApiDatasource;

  AuthRepositoryImpl({required this.authApiDatasource});
  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final either = await authApiDatasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return either.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, UserEntity>> registerAccount({
    required RegisterParams params,
  }) async {
    final either = await authApiDatasource.registerAccount(
      email: params.email,
      password: params.password,
    );
    return either.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
