import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class Register extends Usecase<RegisterParams, UserEntity> {
  final AuthRepository repository;

  Register({required this.repository});
  @override
  Future<Either<Failure, UserEntity>> call({
    required RegisterParams params,
  }) async {
    final result = await repository.registerAccount(params: params);

    return result;
  }
}

class RegisterParams {
  final String email;
  final String name;
  final String gender;
  final String? profilePictureUrl;
  final String password;

  RegisterParams({
    required this.email,
    required this.name,
    required this.gender,
    this.profilePictureUrl,
    required this.password,
  });
}
