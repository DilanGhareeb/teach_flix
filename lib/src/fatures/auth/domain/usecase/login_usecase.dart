import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class Login extends Usecase<LoginParams, UserEntity> {
  final AuthRepository repository;

  Login({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call({
    required LoginParams params,
  }) async {
    final result = await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );

    return result;
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
