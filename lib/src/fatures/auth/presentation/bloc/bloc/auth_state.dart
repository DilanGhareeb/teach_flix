part of 'auth_bloc.dart';

enum AuthStatus { unauthenticated, loading, authenticated, failure }

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
