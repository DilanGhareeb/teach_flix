part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

final class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String gender;
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
  });
  @override
  List<Object?> get props => [name, email, password, gender];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
