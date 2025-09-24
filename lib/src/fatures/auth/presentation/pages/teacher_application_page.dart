import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/fatures/auth/domain/usecase/update_user_info_usecase.dart';

class TeacherApplicationPage extends StatefulWidget {
  const TeacherApplicationPage({super.key});

  @override
  State<TeacherApplicationPage> createState() => _TeacherApplicationPageState();
}

class _TeacherApplicationPageState extends State<TeacherApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  File? _teacherIdImage;
  bool _isSubmitting = false;

  final categories = [
    'Mathematics',
    'Science',
    'Languages',
    'History',
    'Computer Science',
    'Arts',
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _teacherIdImage = File(picked.path);
      });
    }
  }

  Future<Uint8List> _fileToUint8List(File file) async {
    return await file.readAsBytes();
  }

  void _submitApplication() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_teacherIdImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.please_upload_id)),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Convert image to Uint8List
      final imageBytes = await _fileToUint8List(_teacherIdImage!);

      // Create update params to change role to teacher and upload ID image
      final updateParams = UpdateUserParams(
        null, // name - keeping current name
        null, // gender - keeping current gender
        imageBytes, // teacher ID image
        role: Role.instructor, // changing role to teacher
      );

      // Dispatch the update user event
      context.read<AuthBloc>().add(AuthUpdateUserRequested(updateParams));
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.apply_teacher)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated && _isSubmitting) {
            // Application submitted successfully
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.application_submitted,
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state.status == AuthStatus.failure && _isSubmitting) {
            // Handle submission failure
            setState(() {
              _isSubmitting = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Application failed: ${state.failure?.toString() ?? 'Unknown error'}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  /// CATEGORY SELECT
                  Text(t.select_category, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    initialValue: _selectedCategory,
                    validator: (value) =>
                        value == null ? t.field_required : null,
                    onChanged: _isSubmitting
                        ? null
                        : (val) {
                            setState(() {
                              _selectedCategory = val;
                            });
                          },
                  ),
                  const SizedBox(height: 24),

                  /// TEACHER ID UPLOAD
                  Text(t.upload_teacher_id, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _isSubmitting ? null : _pickImage,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isSubmitting
                              ? theme.disabledColor
                              : theme.dividerColor,
                          width: 1.2,
                        ),
                        color: _isSubmitting
                            ? theme.disabledColor.withOpacity(0.1)
                            : theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: _teacherIdImage == null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    size: 40,
                                    color: _isSubmitting
                                        ? theme.disabledColor
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    t.tap_to_upload,
                                    style: TextStyle(
                                      color: _isSubmitting
                                          ? theme.disabledColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _teacherIdImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                if (!_isSubmitting)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: _pickImage,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _submitApplication,
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(t.submit_application),
                              ],
                            )
                          : Text(
                              t.submit_application,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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
