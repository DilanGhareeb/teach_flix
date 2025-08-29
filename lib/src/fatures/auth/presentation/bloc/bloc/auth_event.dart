part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class AuthBootstrapRequested extends AuthEvent {
  const AuthBootstrapRequested();
}

final class _AuthSessionChanged extends AuthEvent {
  final AuthSession session;
  const _AuthSessionChanged(this.session);
  @override
  List<Object?> get props => [session.uid];
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
  final Uint8List? avatarBytes;
  final String? avatarFileName;
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    this.avatarBytes,
    this.avatarFileName,
  });
  @override
  List<Object?> get props => [
    name,
    email,
    password,
    gender,
    avatarBytes,
    avatarFileName,
  ];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
