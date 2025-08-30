import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/pages/register_page.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(localization.login)),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == AuthStatus.failure && state.failure != null) {
            final localization = AppLocalizations.of(context)!;
            final text = ErrorLocalizer.of(state.failure!, localization);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  text,
                  style: TextStyle(
                    fontFamily: AppTheme.getFontFamily(languageCode),
                  ),
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: localization.email),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: localization.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (p, c) => p.status != c.status,
                builder: (context, state) {
                  final busy = state.status == AuthStatus.loading;
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: busy
                          ? null
                          : () => context.read<AuthBloc>().add(
                              AuthLoginRequested(
                                emailCtrl.text.trim(),
                                passCtrl.text,
                              ),
                            ),
                      child: busy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(localization.login),
                    ),
                  );
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(localization.noAccount),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(localization.createAccount),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
