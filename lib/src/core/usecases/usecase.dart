import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';

abstract class Usecase<Input, Output> {
  Future<Either<Failure, Output>> call({required Input params});
}
