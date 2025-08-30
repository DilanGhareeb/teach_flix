import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String gender = 'unspecified';
  bool obscure = true;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        name: name,
        email: email,
        password: pass,
        gender: gender,
      ),
    );
  }

  InputDecoration _dec(
    BuildContext context,
    String label, {
    Widget? suffix,
    Widget? prefix,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      prefixIcon: prefix,
      suffixIcon: suffix,
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
        listener: (context, state) async {
          if (state.status == AuthStatus.failure && state.failure != null) {
            final msg = ErrorLocalizer.of(state.failure!, localization);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  msg,
                  style: TextStyle(
                    fontFamily: AppTheme.getFontFamily(languageCode),
                  ),
                ),
              ),
            );
          }
          if (state.status == AuthStatus.authenticated && mounted) {
            Navigator.of(context).pop();
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
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localization.createAccount,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              localization.fillYourDetails,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: nameCtrl,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              decoration: _dec(
                                context,
                                localization.name,
                                prefix: const Icon(Icons.badge_rounded),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return localization.errFieldRequired;
                                if (v.trim().length < 2)
                                  return localization.errNameTooShort;
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              decoration: _dec(
                                context,
                                localization.email,
                                prefix: const Icon(Icons.mail_rounded),
                              ),
                              validator: (v) {
                                final value = v?.trim() ?? '';
                                if (value.isEmpty)
                                  return localization.errFieldRequired;
                                final emailRe = RegExp(
                                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                );
                                if (!emailRe.hasMatch(value))
                                  return localization.errInvalidEmail;
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: passCtrl,
                              obscureText: obscure,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              onFieldSubmitted: (_) => _submit(context),
                              decoration: _dec(
                                context,
                                localization.password,
                                prefix: const Icon(Icons.lock_rounded),
                                suffix: IconButton(
                                  icon: Icon(
                                    obscure
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                  ),
                                  onPressed: () =>
                                      setState(() => obscure = !obscure),
                                ),
                              ),
                              validator: (v) {
                                final value = v ?? '';
                                if (value.isEmpty) {
                                  return localization.errFieldRequired;
                                }
                                if (value.length < 6) {
                                  return localization.errPasswordTooShort(6);
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: gender,
                              items: [
                                DropdownMenuItem(
                                  value: 'unspecified',
                                  child: Text(localization.unspecified),
                                ),
                                DropdownMenuItem(
                                  value: 'male',
                                  child: Text(localization.male),
                                ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Text(localization.female),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => gender = v ?? gender),
                              decoration: _dec(
                                context,
                                localization.gender,
                                prefix: const Icon(
                                  Icons.person_outline_rounded,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            BlocBuilder<AuthBloc, AuthState>(
                              buildWhen: (p, c) => p.status != c.status,
                              builder: (context, state) {
                                final busy = state.status == AuthStatus.loading;
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
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(localization.createAccount),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
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
