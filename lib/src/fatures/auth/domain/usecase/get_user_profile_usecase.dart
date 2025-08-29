import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class GetUserProfile extends Usecase<String, UserEntity> {
  final AuthRepository repository;
  GetUserProfile({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call({required String params}) {
    return repository.fetchUserById(params);
  }
}
