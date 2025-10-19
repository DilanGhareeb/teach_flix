import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:teach_flix/src/features/common/error_localizer.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool emailSent = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthPasswordResetRequested(emailCtrl.text.trim()),
    );
  }

  InputDecoration _dec(BuildContext context, String label, {Widget? prefix}) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      prefixIcon: prefix,
      filled: true,
      fillColor: cs.surface.withOpacity(0.6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == AuthStatus.failure && state.failure != null) {
            final text = ErrorLocalizer.of(state.failure!, localization);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  text,
                  style: TextStyle(
                    fontFamily: AppTheme.getFontFamily(languageCode),
                  ),
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state.status == AuthStatus.unauthenticated && !emailSent) {
            setState(() => emailSent = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  localization.password_reset_email_sent ??
                      'Password reset email sent! Check your inbox.',
                  style: TextStyle(
                    fontFamily: AppTheme.getFontFamily(languageCode),
                  ),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.surface, cs.surfaceContainerHighest],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!emailSent) ...[
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: cs.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.lock_reset_rounded,
                                  color: cs.primary,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                localization.forgot_password ??
                                    'Forgot Password?',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                localization.forgot_password_description ??
                                    'Enter your email address and we\'ll send you a link to reset your password.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(context),
                                decoration: _dec(
                                  context,
                                  localization.email,
                                  prefix: const Icon(Icons.mail_rounded),
                                ),
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) {
                                    return localization.errFieldRequired;
                                  }
                                  final emailRe = RegExp(
                                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                  );
                                  if (!emailRe.hasMatch(value)) {
                                    return localization.errInvalidEmail;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              BlocBuilder<AuthBloc, AuthState>(
                                buildWhen: (p, c) => p.status != c.status,
                                builder: (context, state) {
                                  final busy =
                                      state.status == AuthStatus.loading;
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: FilledButton(
                                      onPressed: busy
                                          ? null
                                          : () => _submit(context),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: busy
                                            ? const SizedBox(
                                                key: ValueKey('spin'),
                                                height: 22,
                                                width: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Text(
                                                localization.send_reset_link ??
                                                    'Send Reset Link',
                                                key: const ValueKey('txt'),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ] else ...[
                              // Success State
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green,
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                localization.email_sent ?? 'Email Sent!',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                localization.check_email_for_reset_link ??
                                    'We\'ve sent a password reset link to',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                emailCtrl.text.trim(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: FilledButton.icon(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: Text(
                                    localization.back_to_login ??
                                        'Back to Login',
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            if (!emailSent)
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  localization.back_to_login ?? 'Back to Login',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
