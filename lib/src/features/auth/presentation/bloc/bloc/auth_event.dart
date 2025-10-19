part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class AuthBootstrapRequested extends AuthEvent {
  const AuthBootstrapRequested();
}

// New event to continue as guest
final class AuthContinueAsGuestRequested extends AuthEvent {
  const AuthContinueAsGuestRequested();
}

final class _AuthSessionChanged extends AuthEvent {
  final AuthSession session;
  const _AuthSessionChanged(this.session);
  @override
  List<Object?> get props => [session.uid];
}

class _AuthProfileChanged extends AuthEvent {
  final UserEntity user;
  const _AuthProfileChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class _AuthProfileFailed extends AuthEvent {
  final Failure failure;
  const _AuthProfileFailed(this.failure);
  @override
  List<Object?> get props => [failure];
}

final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

final class AuthUpdateUserRequested extends AuthEvent {
  final UpdateUserParams params;
  const AuthUpdateUserRequested(this.params);
  @override
  List<Object?> get props => [params];
}

final class AuthDepositRequested extends AuthEvent {
  final double amount;
  const AuthDepositRequested(this.amount);
  @override
  List<Object?> get props => [amount];
}

final class AuthWithdrawRequested extends AuthEvent {
  final double amount;
  const AuthWithdrawRequested(this.amount);
  @override
  List<Object?> get props => [amount];
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
