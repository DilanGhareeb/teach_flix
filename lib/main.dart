// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kurdish_localization/kurdish_cupertino_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_material_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_widget_localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teach_flix/firebase_options.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/pages/login_page.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/fatures/common/presentation/pages/main_page.dart';
import 'package:teach_flix/src/fatures/settings/presentation/bloc/settings_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
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
        if (state.status == AuthStatus.failure && state.failure != null) {
          final localization = AppLocalizations.of(context)!;
          final text = ErrorLocalizer.of(state.failure!, localization);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
        }
      },
      builder: (context, state) {
        if (state.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == AuthStatus.authenticated) {
          return const KeyedSubtree(
            key: ValueKey('main-shell'),
            child: MainPage(),
          );
        }
        return const KeyedSubtree(
          key: ValueKey('login-shell'),
          child: LoginPage(),
        );
      },
    );
  }
}
