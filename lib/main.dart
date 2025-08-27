import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kurdish_localization/kurdish_cupertino_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_material_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_widget_localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teach_flix/firebase_options.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/fatures/common/presentation/pages/main_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: MainPage(),
    );
  }
}
