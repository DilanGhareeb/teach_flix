import 'package:get_it/get_it.dart';
import 'package:teach_flix/src/fatures/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/fatures/auth/data/repositories/auth_repository_impl.dart';
import 'package:teach_flix/src/fatures/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl
    ..registerLazySingleton<AuthApiDatasource>(() => AuthApiDatasourceImpl())
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authApiDatasource: sl()),
    )
    ..registerLazySingleton<Login>(() => Login(repository: sl()))
    ..registerLazySingleton<Register>(() => Register(repository: sl()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(loginUsecase: sl(), registerUsecase: sl()),
    );
}
