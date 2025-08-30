import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/fatures/common/presentation/pages/main_page.dart';
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

  Uint8List? avatarBytes;
  String? avatarFileName;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      avatarBytes = bytes;
      avatarFileName = picked.name;
    });
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
        avatarBytes: avatarBytes,
        avatarFileName: avatarFileName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(localization.register)),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage: avatarBytes != null
                          ? MemoryImage(avatarBytes!)
                          : null,
                      child: avatarBytes == null
                          ? const Icon(Icons.add_a_photo, size: 28)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    decoration: InputDecoration(labelText: localization.name),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return localization.errFieldRequired;
                      }
                      if (v.trim().length < 2) {
                        return localization.errNameTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(labelText: localization.email),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return localization.errFieldRequired;
                      final emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                      if (!emailRe.hasMatch(value)) {
                        return localization.errInvalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passCtrl,
                    obscureText: obscure,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    onFieldSubmitted: (_) => _submit(context),
                    decoration: InputDecoration(
                      labelText: localization.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    ),
                    validator: (v) {
                      final value = v ?? '';
                      if (value.isEmpty) return localization.errFieldRequired;
                      if (value.length < 6) {
                        return localization.errPasswordTooShort(6);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
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
                    onChanged: (v) => setState(() => gender = v ?? gender),
                    decoration: InputDecoration(labelText: localization.gender),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (p, c) => p.status != c.status,
                    builder: (context, state) {
                      final busy = state.status == AuthStatus.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: busy ? null : () => _submit(context),
                          child: busy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(localization.createAccount),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
