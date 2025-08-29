part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
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

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
