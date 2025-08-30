import 'dart:async';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/watch_user_profile_usecase.dart';
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
  final WatchUserProfile getUserProfile;
  final Logout logoutUsecase;

  StreamSubscription<AuthSession>? _authSub;
  StreamSubscription<Either<Failure, UserEntity>>? _profileSub;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.watchAuthSession,
    required this.getUserProfile,
    required this.logoutUsecase,
  }) : super(const AuthState()) {
    on<AuthBootstrapRequested>(_onBootstrap);
    on<_AuthSessionChanged>(_onSessionChanged);

    on<_AuthProfileChanged>(_onProfileChanged);
    on<_AuthProfileFailed>(_onProfileFailed);

    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onBootstrap(
    AuthBootstrapRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, failure: null));
    await _authSub?.cancel();
    _authSub = watchAuthSession().listen((s) => add(_AuthSessionChanged(s)));
  }

  Future<void> _onSessionChanged(
    _AuthSessionChanged e,
    Emitter<AuthState> emit,
  ) async {
    await _profileSub?.cancel();

    if (!e.session.isAuthenticated) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, failure: null));

    _profileSub = getUserProfile(params: e.session.uid!).listen(
      (either) => either.fold(
        (f) => add(_AuthProfileFailed(f)),
        (user) => add(_AuthProfileChanged(user)),
      ),
      onError: (err, st) => add(_AuthProfileFailed(UnknownFailure())),
    );
  }

  void _onProfileChanged(_AuthProfileChanged e, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: e.user,
        failure: null,
      ),
    );
  }

  void _onProfileFailed(_AuthProfileFailed e, Emitter<AuthState> emit) {
    emit(state.copyWith(status: AuthStatus.failure, failure: e.failure));
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
      ),
    );
    r.fold(
      (f) => emit(state.copyWith(status: AuthStatus.failure, failure: f)),
      (_) {},
    );
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await _profileSub?.cancel();
    await logoutUsecase();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _profileSub?.cancel();
    return super.close();
  }
}
