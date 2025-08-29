import 'dart:async';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/get_user_profile_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/watch_auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;
  final Register registerUsecase;
  final WatchAuthSession watchAuthSession;
  final GetUserProfile getUserProfile;
  final Logout logoutUsecase;

  StreamSubscription<AuthSession>? _sub;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.watchAuthSession,
    required this.getUserProfile,
    required this.logoutUsecase,
  }) : super(const AuthState()) {
    on<AuthBootstrapRequested>(_onBootstrap);
    on<_AuthSessionChanged>(_onSessionChanged);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onBootstrap(
    AuthBootstrapRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, failure: null));
    await _sub?.cancel();
    _sub = watchAuthSession().listen((s) => add(_AuthSessionChanged(s)));
  }

  Future<void> _onSessionChanged(
    _AuthSessionChanged e,
    Emitter<AuthState> emit,
  ) async {
    if (!e.session.isAuthenticated) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }
    final res = await getUserProfile(params: e.session.uid!);
    res.fold(
      (f) => emit(AuthState(status: AuthStatus.failure, failure: f)),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, failure: null));
    final r = await loginUsecase(
      params: LoginParams(email: e.email, password: e.password),
    );
    r.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, failure: f)),
      (_) {},
    );
  }

  Future<void> _onRegister(
    AuthRegisterRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, failure: null));
    final r = await registerUsecase(
      params: RegisterParams(
        name: e.name,
        email: e.email,
        password: e.password,
        gender: e.gender,
        profilePictureUrl: null,
      ),
    );
    r.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, failure: f)),
      (_) {},
    );
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await logoutUsecase();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
