import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
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
  bool _imageRemoved = false;

  // Original values to track changes
  String _originalName = '';
  String _originalGender = 'unspecified';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    _originalName = user?.name ?? '';
    _originalGender = user?.gender ?? 'unspecified';
    _nameCtrl.text = _originalName;
    _gender = _originalGender;

    // Listen to name changes
    _nameCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  // Check if any changes were made
  bool get _hasChanges {
    final nameChanged = _nameCtrl.text.trim() != _originalName;
    final genderChanged = _gender != _originalGender;
    final imageChanged = _imageBytes != null || _imageRemoved;
    return nameChanged || genderChanged || imageChanged;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
      _imageRemoved = false;
    });
  }

  Future<void> _showImageSheet() async {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    t.change_photo ?? 'Change Photo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(t.gallery),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_camera,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  title: Text(t.camera),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_imageBytes != null ||
                    (context.read<AuthBloc>().state.user?.profilePictureUrl !=
                        null))
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    title: Text(t.remove_photo),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _imageBytes = null;
                        _imageRemoved = true;
                      });
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showGenderSheet() async {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final options = <String, String>{
      'unspecified': t.unspecified,
      'male': t.male,
      'female': t.female,
    };

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    t.select_gender ?? 'Select Gender',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (final entry in options.entries)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(entry.value),
                    trailing: _gender == entry.key
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: theme.colorScheme.primary,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                    onTap: () => Navigator.of(ctx).pop(entry.key),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted) return;
    if (selected != null) setState(() => _gender = selected);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) return;

    setState(() => _saving = true);

    final params = UpdateUserParams(
      _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
      _gender,
      _imageBytes,
      removePhoto: _imageRemoved,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (userState.status == AuthStatus.authenticated) {
          setState(() => _saving = false);
          Navigator.of(context).maybePop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Text(t.profile_updated),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });

    final currentPhoto = userState.user?.profilePictureUrl;

    ImageProvider? avatarProvider;
    if (_imageBytes != null) {
      avatarProvider = MemoryImage(_imageBytes!);
    } else if (!_imageRemoved &&
        currentPhoto != null &&
        currentPhoto.isNotEmpty) {
      avatarProvider = CachedNetworkImageProvider(currentPhoto);
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.edit_profile), elevation: 0),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                // Profile Picture Section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.2,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              backgroundImage: avatarProvider,
                              child: avatarProvider == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                    )
                                  : null,
                            ),
                          ),
                          Material(
                            color: theme.colorScheme.primary,
                            shape: const CircleBorder(),
                            elevation: 4,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _showImageSheet,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_hasChanges && _imageBytes != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                t.photo_changed ?? 'Photo changed',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form Section
                Text(
                  t.personal_information ?? 'Personal Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: SectionCard(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: TextFormField(
                          controller: _nameCtrl,
                          textInputAction: TextInputAction.done,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            labelText: t.name,
                            hintText: t.name_hint,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: theme.colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (v) {
                            final s = v?.trim() ?? '';
                            if (s.isEmpty) return t.name_required;
                            if (s.length < 2) return t.name_too_short;
                            return null;
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _gender == 'male'
                                ? Icons.male
                                : _gender == 'female'
                                ? Icons.female
                                : Icons.person_outline,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          t.gender,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        subtitle: Text(
                          _gender == 'male'
                              ? t.male
                              : _gender == 'female'
                              ? t.female
                              : t.unspecified,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        onTap: _showGenderSheet,
                      ),
                    ],
                  ),
                ),

                if (_hasChanges) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        0.3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t.unsaved_changes ?? 'You have unsaved changes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            // Bottom Action Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: FilledButton(
                    onPressed:
                        (_saving ||
                            userState.status == AuthStatus.loading ||
                            !_hasChanges)
                        ? null
                        : _save,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: (_saving || userState.status == AuthStatus.loading)
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save_rounded),
                              const SizedBox(width: 8),
                              Text(
                                t.save_changes,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
