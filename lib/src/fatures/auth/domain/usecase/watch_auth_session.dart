import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';

class WatchAuthSession extends NoParamsStreamUsecase<AuthSession> {
  final AuthRepository repository;

  WatchAuthSession({required this.repository});

  @override
  Stream<AuthSession> call() => repository.watchSession();
}
