import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class WatchUserProfile extends StreamUsecase<String, UserEntity> {
  final AuthRepository repository;
  WatchUserProfile({required this.repository});

  @override
  Stream<Either<Failure, UserEntity>> call({required String params}) {
    return repository.watchUserById(params);
  }
}
