import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';
import 'package:teach_flix/src/features/auth/domain/repositories/auth_repository.dart';

class Register extends Usecase<RegisterParams, UserEntity> {
  final AuthRepository repository;
  Register({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call({required RegisterParams params}) {
    return repository.registerAccount(params: params);
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String gender;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
  });

  RegisterParams copyWith({
    String? name,
    String? email,
    String? password,
    String? gender,
  }) {
    return RegisterParams(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
    );
  }
}
