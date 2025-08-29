import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/fatures/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/fatures/auth/data/repositories/auth_repository_impl.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/get_user_profile_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/watch_auth_session.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/logout_usecase.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';

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
  sl.registerFactory(() => GetUserProfile(repository: sl()));
  sl.registerFactory(() => Login(repository: sl()));
  sl.registerFactory(() => Register(repository: sl()));
  sl.registerFactory(() => Logout(repository: sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      watchAuthSession: sl(),
      getUserProfile: sl(),
      logoutUsecase: sl(),
    ),
  );
}
