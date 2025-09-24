// lib/src/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth
import 'package:teach_flix/src/fatures/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/fatures/auth/data/repositories/auth_repository_impl.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/watch_user_profile_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/watch_auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/logout_usecase.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';

import 'package:teach_flix/src/fatures/settings/data/datasources/app_prefernce_local.dart';
import 'package:teach_flix/src/fatures/settings/data/repositories/app_preference_repository_impl.dart';
import 'package:teach_flix/src/fatures/settings/domain/repositories/app_preference_repository.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/change_language_code.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/change_theme_usecase.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/get_language_code.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/get_theme_usecase.dart';
import 'package:teach_flix/src/fatures/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<AuthApiDatasource>(
    () => AuthApiDatasourceImpl(
      fireStore: sl<FirebaseFirestore>(),
      fireAuth: sl<FirebaseAuth>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authApiDatasource: sl()),
  );
  sl.registerFactory(() => WatchAuthSession(repository: sl()));
  sl.registerFactory(() => WatchUserProfile(repository: sl()));
  sl.registerFactory(() => Login(repository: sl()));
  sl.registerFactory(() => Register(repository: sl()));
  sl.registerFactory(() => UpdateUserInfo(sl()));
  sl.registerFactory(() => Logout(repository: sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      watchAuthSession: sl(),
      getUserProfile: sl(),
      updateUserInfo: sl(),
      logoutUsecase: sl(),
    ),
  );

  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });

  await sl.isReady<SharedPreferences>();

  sl.registerLazySingleton<AppPreferenceLocal>(
    () => AppPreferenceLocalImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AppPreferenceRepository>(
    () => AppPreferenceRepositoryImpl(sl<AppPreferenceLocal>()),
  );

  sl.registerFactory(() => GetLanguageCode(sl<AppPreferenceRepository>()));
  sl.registerFactory(() => GetTheme(sl<AppPreferenceRepository>()));
  sl.registerFactory(() => ChangeLanguageCode(sl<AppPreferenceRepository>()));
  sl.registerFactory(() => ChangeTheme(sl<AppPreferenceRepository>()));

  sl.registerFactory(
    () => SettingsBloc(
      getLanguageCode: sl(),
      getTheme: sl(),
      changeLanguageCode: sl(),
      changeTheme: sl(),
    ),
  );
}
