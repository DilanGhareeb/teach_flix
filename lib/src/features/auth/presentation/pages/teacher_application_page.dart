import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:teach_flix/src/features/auth/presentation/widgets/application_header_card.dart';
import 'package:teach_flix/src/features/auth/presentation/widgets/category_dropdown.dart';
import 'package:teach_flix/src/features/auth/presentation/widgets/id_image_upload_card.dart';
import 'package:teach_flix/src/features/auth/presentation/widgets/image_source_bottom_sheet.dart';
import 'package:teach_flix/src/features/auth/presentation/widgets/info_card.dart';
import 'package:teach_flix/src/features/auth/presentation/widgets/section_header.dart';
import 'package:teach_flix/src/features/auth/presentation/widgets/submit_button.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_category.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class TeacherApplicationPage extends StatefulWidget {
  const TeacherApplicationPage({super.key});

  @override
  State<TeacherApplicationPage> createState() => _TeacherApplicationPageState();
}

class _TeacherApplicationPageState extends State<TeacherApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  CourseCategory? _selectedCategory;
  File? _frontIdImage;
  File? _backIdImage;
  bool _isSubmitting = false;
  bool _hasNavigated = false;

  Future<void> _pickAndCropImage(bool isFront) async {
    final source = await _showImageSourceDialog();
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: picked.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppLocalizations.of(context)!.crop_image,
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: AppLocalizations.of(context)!.crop_image,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          if (isFront) {
            _frontIdImage = File(croppedFile.path);
          } else {
            _backIdImage = File(croppedFile.path);
          }
        });
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImageSourceBottomSheet(),
    );
  }

  Future<Uint8List> _fileToUint8List(File file) async {
    return await file.readAsBytes();
  }

  Future<Uint8List> _combineImages() async {
    // TODO: Implement image combination logic
    // For now, return front image bytes
    return await _fileToUint8List(_frontIdImage!);
  }

  void _submitApplication() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_frontIdImage == null || _backIdImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.please_upload_both_ids),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final imageBytes = await _combineImages();

      final updateParams = UpdateUserParams(
        null,
        null,
        imageBytes,
        role: Role.instructor,
      );

      context.read<AuthBloc>().add(AuthUpdateUserRequested(updateParams));
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.error}: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(t.apply_teacher),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Prevent multiple navigations
          if (_hasNavigated) return;

          if (state.status == AuthStatus.authenticated && _isSubmitting) {
            _hasNavigated = true;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(t.application_submitted)),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Use a delayed pop to ensure the snackbar is visible
            // and to avoid navigation conflicts
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          } else if (state.status == AuthStatus.failure && _isSubmitting) {
            setState(() {
              _isSubmitting = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${t.application_failed}: ${state.failure?.toString() ?? t.unknown_error}',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Header Section
                      ApplicationHeaderCard(
                        title: t.become_instructor,
                        subtitle: t.share_your_knowledge,
                      ),
                      const SizedBox(height: 32),

                      // Category Section
                      SectionHeader(
                        icon: Icons.category_rounded,
                        title: t.select_category,
                      ),
                      const SizedBox(height: 12),
                      CategoryDropdown(
                        selectedCategory: _selectedCategory,
                        languageCode: languageCode,
                        isEnabled: !_isSubmitting,
                        onChanged: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        validator: (value) =>
                            value == null ? t.field_required : null,
                      ),
                      const SizedBox(height: 32),

                      // ID Upload Section
                      SectionHeader(
                        icon: Icons.badge_rounded,
                        title: t.upload_teacher_id,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.upload_both_sides,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Front ID
                      IdImageUploadCard(
                        label: t.front_id,
                        image: _frontIdImage,
                        isEnabled: !_isSubmitting,
                        onTap: () => _pickAndCropImage(true),
                      ),
                      const SizedBox(height: 16),

                      // Back ID
                      IdImageUploadCard(
                        label: t.back_id,
                        image: _backIdImage,
                        isEnabled: !_isSubmitting,
                        onTap: () => _pickAndCropImage(false),
                      ),
                      const SizedBox(height: 32),

                      // Info Card
                      InfoCard(message: t.application_review_info),
                      const SizedBox(height: 32),

                      // Submit Button
                      SubmitButton(
                        isSubmitting: _isSubmitting,
                        onPressed: _submitApplication,
                        label: t.submit_application,
                      ),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
