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
    final res = await authApiDatasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.map((m) => m);
  }

  @override
  Future<Either<Failure, UserEntity>> registerAccount({
    required RegisterParams params,
  }) async {
    final res = await authApiDatasource.registerAccount(params: params);
    return res.map((m) => m);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return authApiDatasource.signOut();
  }
}
