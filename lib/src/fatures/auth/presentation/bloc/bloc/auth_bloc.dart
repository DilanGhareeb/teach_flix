import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;
  final Register registerUsecase;

  AuthBloc({required this.loginUsecase, required this.registerUsecase})
    : super(const AuthState()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, failure: null));
    final result = await loginUsecase(
      params: LoginParams(email: e.email, password: e.password),
    );
    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, failure: f)),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onRegister(
    AuthRegisterRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, failure: null));
    final result = await registerUsecase(
      params: RegisterParams(
        name: e.name,
        email: e.email,
        password: e.password,
        gender: e.gender,
        profilePictureUrl: null,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, failure: f)),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    emit(const AuthState());
  }
}
