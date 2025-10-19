import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';

enum AuthStatus { unauthenticated, guest, loading, authenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final Failure? failure;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.failure,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    Failure? failure,
  }) => AuthState(
    status: status ?? this.status,
    user: user ?? this.user,
    failure: failure,
  );

  @override
  List<Object?> get props => [status, user, failure];
}
