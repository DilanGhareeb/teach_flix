import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;
  Logout({required this.repository});
  Future<Either<Failure, void>> call() => repository.signOut();
}
