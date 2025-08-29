import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kurdish_localization/kurdish_cupertino_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_material_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_widget_localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teach_flix/firebase_options.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/common/presentation/pages/main_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/fatures/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/fatures/auth/data/repositories/auth_repository_impl.dart';
import 'package:teach_flix/src/fatures/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = AuthApiDatasourceImpl();
    final repo = AuthRepositoryImpl(authApiDatasource: ds);
    final login = Login(repository: repo);
    final register = RegisterUsecase(repository: repo);

    return BlocProvider(
      create: (_) => AuthBloc(loginUsecase: login, registerUsecase: register),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ckb'),
        supportedLocales: const [Locale('en'), Locale('ckb')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          KurdishMaterialLocalizations.delegate,
          KurdishCupertinoLocalizations.delegate,
          KurdishWidgetLocalizations.delegate,
        ],
        theme: AppTheme.light('ckb'),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) return const MainPage();
        if (state.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const LoginPage();
      },
    );
  }
}
