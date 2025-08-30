import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/fatures/settings/presentation/widgets/section_card.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String _gender = 'unspecified';
  Uint8List? _imageBytes;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    _nameCtrl.text = user?.name ?? '';
    _gender = user?.gender ?? 'unspecified';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() => _imageBytes = bytes);
  }

  Future<void> _showImageSheet() async {
    final t = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(t.gallery),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(t.camera),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_imageBytes != null) const Divider(),
              if (_imageBytes != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(t.remove_photo),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _imageBytes = null);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showGenderSheet() async {
    final t = AppLocalizations.of(context)!;
    final options = <String, String>{
      'unspecified': t.unspecified,
      'male': t.male,
      'female': t.female,
    };
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in options.entries)
                ListTile(
                  title: Text(entry.value),
                  trailing: _gender == entry.key
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () => Navigator.of(ctx).pop(entry.key),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (!mounted) return;
    if (selected != null) setState(() => _gender = selected);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final params = UpdateUserParams(
      _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
      _gender,
      _imageBytes,
    );

    context.read<AuthBloc>().add(AuthUpdateUserRequested(params));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final userState = context.watch<AuthBloc>().state;

    // react to loading / done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_saving) {
        if (userState.status == AuthStatus.failure) {
          setState(() => _saving = false);
          final msg = ErrorLocalizer.of(userState.failure!, t);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        } else if (userState.status == AuthStatus.authenticated) {
          setState(() => _saving = false);
          Navigator.of(context).maybePop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.profile_updated)));
        }
      }
    });

    final currentPhoto = userState.user?.profilePictureUrl;

    ImageProvider? avatarProvider;
    if (_imageBytes != null) {
      avatarProvider = MemoryImage(_imageBytes!);
    } else if (currentPhoto != null && currentPhoto.isNotEmpty) {
      avatarProvider = NetworkImage(currentPhoto);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.edit_profile),
        actions: [
          TextButton(
            onPressed: (_saving || userState.status == AuthStatus.loading)
                ? null
                : _save,
            child: (_saving || userState.status == AuthStatus.loading)
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(t.save),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: avatarProvider,
                    child: avatarProvider == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  Material(
                    color: theme.colorScheme.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _showImageSheet,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: SectionCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: TextFormField(
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: t.name,
                        hintText: t.name_hint,
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return t.name_required;
                        if (s.length < 2) return t.name_too_short;
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(t.gender),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _gender == 'male'
                              ? t.male
                              : _gender == 'female'
                              ? t.female
                              : t.unspecified,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    onTap: _showGenderSheet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: (_saving || userState.status == AuthStatus.loading)
                  ? null
                  : _save,
              icon: const Icon(Icons.save_rounded),
              label: Text(t.save_changes),
            ),
          ],
        ),
      ),
    );
  }
}
