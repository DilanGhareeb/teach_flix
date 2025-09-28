import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kurdish_localization/kurdish_cupertino_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_material_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_widget_localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teach_flix/firebase_options.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/pages/login_page.dart';
import 'package:teach_flix/src/fatures/common/presentation/pages/main_page.dart';
import 'package:teach_flix/src/fatures/settings/presentation/bloc/settings_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthBootstrapRequested()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) =>
              sl<SettingsBloc>()..add(const SettingsBootstrapRequested()),
        ),
        BlocProvider<CoursesBloc>(
          create: (_) => sl<CoursesBloc>()..add(LoadCoursesEvent()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settings) {
          final locale = Locale(settings.languageCode);
          final isDarkMode = settings.isDark;
          return MaterialApp(
            title: 'Teach Flix',
            debugShowCheckedModeBanner: false,
            locale: locale,
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
            theme: isDarkMode
                ? AppTheme.dark(settings.languageCode)
                : AppTheme.light(settings.languageCode),
            home: _AuthGate(),
          );
        },
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == AuthStatus.failure && state.failure != null) {}
      },
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.authenticated:
            return const MainPage();
          case AuthStatus.unauthenticated:
            return const LoginPage();
          case AuthStatus.failure:
            return const LoginPage();
        }
      },
    );
  }
}
