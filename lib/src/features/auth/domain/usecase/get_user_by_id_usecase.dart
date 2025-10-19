import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';
import 'package:teach_flix/src/features/auth/domain/repositories/auth_repository.dart';

class GetUserById {
  final AuthRepository repository;

  GetUserById(this.repository);

  Future<Either<Failure, UserEntity>> call({required String params}) async {
    return await repository.getUserById(params);
  }
}
