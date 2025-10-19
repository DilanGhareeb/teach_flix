import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/common/error_localizer.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_category.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/pages/add_chapter_page.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CreateCoursePage extends StatefulWidget {
  final CourseEntity? existingCourse; // NEW: Optional course for editing

  const CreateCoursePage({super.key, this.existingCourse});

  // Helper getter to check if in edit mode
  bool get isEditMode => existingCourse != null;

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _previewVideoUrlController = TextEditingController();

  String _selectedCategory = CourseCategory.programming.englishName;

  final List<String> _categories = CourseCategory.allCategoryNames;

  @override
  void initState() {
    super.initState();

    // NEW: Pre-fill form if editing
    if (widget.existingCourse != null) {
      _titleController.text = widget.existingCourse!.title;
      _descriptionController.text = widget.existingCourse!.description;
      _priceController.text = widget.existingCourse!.price.toString();
      _previewVideoUrlController.text =
          widget.existingCourse!.previewVideoUrl ?? '';
      _selectedCategory = widget.existingCourse!.category;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditMode) {
        // NEW: Load existing course data into state
        context.read<CoursesBloc>().add(
          LoadExistingCourseForEditEvent(widget.existingCourse!),
        );
      } else {
        context.read<CoursesBloc>().add(const ClearCourseCreationStateEvent());
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _previewVideoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? t.edit_course : t.create_course),
        elevation: 0,
      ),
      body: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          // NEW: Handle both create and update success
          if (state.status == CoursesStatus.courseCreated ||
              state.status == CoursesStatus.courseUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.isEditMode
                      ? t.course_updated_successfully
                      : t.course_created_successfully,
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state.status == CoursesStatus.failure &&
              state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ErrorLocalizer.of(state.failure!, t)),
                backgroundColor: Colors.red,
              ),
            );
          }
          // NEW: Handle course deletion
          else if (state.status == CoursesStatus.courseDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.course_deleted_successfully),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Thumbnail Section
                        _buildThumbnailSection(context, state, colorScheme, t),

                        const SizedBox(height: 24),

                        // Course Title
                        _buildTextField(
                          controller: _titleController,
                          label: t.course_title,
                          hint: t.enter_course_title,
                          icon: Icons.title_rounded,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return t.title_required;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Course Description
                        _buildTextField(
                          controller: _descriptionController,
                          label: t.description,
                          hint: t.enter_course_description,
                          icon: Icons.description_rounded,
                          maxLines: 4,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return t.description_required;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: t.category,
                            prefixIcon: Icon(
                              Icons.category_rounded,
                              color: colorScheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Price
                        _buildTextField(
                          controller: _priceController,
                          label: t.price,
                          hint: t.enter_price ?? 'Enter price in IQD',
                          icon: Icons
                              .payments_rounded, // Changed to a more appropriate icon
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          textDirection: TextDirection.ltr,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return t.price_required;
                            }
                            final price = double.tryParse(value!);
                            if (price == null) {
                              return t.invalid_price;
                            }
                            if (price < 0) {
                              return t.price_cannot_be_negative ??
                                  'Price cannot be negative';
                            }
                            return null;
                          },
                          suffixText: 'IQD',
                        ),

                        const SizedBox(height: 16),

                        // Preview Video URL
                        _buildTextField(
                          controller: _previewVideoUrlController,
                          label: t.preview_video_url,
                          hint: t.enter_preview_video_url,
                          icon: Icons.video_library_rounded,
                          textDirection: TextDirection.ltr,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return t.preview_video_required;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // Chapters Section
                        _buildChaptersSection(context, state, colorScheme, t),

                        const SizedBox(height: 32),

                        // NEW: Submit Button (Create or Update)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                state.status == CoursesStatus.creating ||
                                    state.status == CoursesStatus.updating ||
                                    state.status == CoursesStatus.imageUploading
                                ? null
                                : _submitCourse,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child:
                                state.status == CoursesStatus.creating ||
                                    state.status == CoursesStatus.updating
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.isEditMode
                                            ? Icons.save_rounded
                                            : Icons.check_circle_rounded,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.isEditMode
                                            ? t.update_course
                                            : t.create_course,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        // NEW: Delete Button (only in edit mode)
                        if (widget.isEditMode) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed: state.status == CoursesStatus.deleting
                                  ? null
                                  : _showDeleteConfirmation,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: state.status == CoursesStatus.deleting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const Icon(Icons.delete_outline),
                              label: Text(
                                t.delete_course,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnailSection(
    BuildContext context,
    CoursesState state,
    ColorScheme colorScheme,
    AppLocalizations t,
  ) {
    // NEW: Show existing image URL if in edit mode and no new image selected
    final showExistingImage =
        widget.isEditMode &&
        state.selectedImage == null &&
        widget.existingCourse?.imageUrl != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.image_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  t.course_thumbnail,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Image Preview
          if (state.selectedImage != null)
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: FileImage(state.selectedImage!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else if (showExistingImage)
            // NEW: Show existing network image
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.existingCourse!.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.no_image_selected,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Image Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<CoursesBloc>().add(
                      PickImageFromGalleryEvent(),
                    ),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: Text(t.gallery),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<CoursesBloc>().add(
                      PickImageFromCameraEvent(),
                    ),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: Text(t.camera),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Unified submit method for create/update
  void _submitCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      final state = context.read<CoursesBloc>().state;

      // NEW: In edit mode, image is optional (can keep existing)
      if (!widget.isEditMode && state.selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.please_upload_thumbnail,
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final authState = context.read<AuthBloc>().state;
      if (authState.user != null) {
        if (widget.isEditMode) {
          // UPDATE existing course
          context.read<CoursesBloc>().add(
            UpdateCourseEvent(
              courseId: widget.existingCourse!.id,
              title: _titleController.text,
              description: _descriptionController.text,
              category: _selectedCategory,
              price: double.parse(_priceController.text),
              previewVideoUrl: _previewVideoUrlController.text,
              instructorId: authState.user!.id,
            ),
          );
        } else {
          // CREATE new course
          context.read<CoursesBloc>().add(
            SubmitNewCourseEvent(
              title: _titleController.text,
              description: _descriptionController.text,
              category: _selectedCategory,
              price: double.parse(_priceController.text),
              previewVideoUrl: _previewVideoUrlController.text,
              instructorId: authState.user!.id,
            ),
          );
        }
      }
    }
  }

  // NEW: Delete confirmation dialog
  void _showDeleteConfirmation() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.delete_course),
        content: Text(t.delete_course_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CoursesBloc>().add(
                DeleteCourseEvent(courseId: widget.existingCourse!.id),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(t.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildChaptersSection(
    BuildContext context,
    CoursesState state,
    ColorScheme colorScheme,
    AppLocalizations t,
  ) {
    final chapters = state.chapters ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      t.chapters,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${chapters.length}',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _addChapter(context),
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          if (chapters.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t.no_chapters_added,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: chapters.length,
              onReorder: (oldIndex, newIndex) {
                context.read<CoursesBloc>().add(
                  ReorderChaptersEvent(oldIndex, newIndex),
                );
              },
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return _buildChapterCard(
                  context,
                  chapter,
                  index,
                  colorScheme,
                  key: ValueKey(chapter.id),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    ChapterEntity chapter,
    int index,
    ColorScheme colorScheme, {
    required Key key,
  }) {
    return Card(
      key: key,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.drag_handle_rounded,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          chapter.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${chapter.videosUrls.length} videos, ${chapter.quizzes.length} quizzes',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
              onPressed: () => _editChapter(context, index, chapter),
              tooltip: AppLocalizations.of(context)!.edit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400]),
              onPressed: () => _removeChapter(context, index),
              tooltip: AppLocalizations.of(context)!.delete,
            ),
          ],
        ),
        onTap: () => _editChapter(context, index, chapter),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? suffixText,
    TextDirection? textDirection,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixText: suffixText, // NEW: Add suffix text
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters, // NEW: Add input formatters
    );
  }

  Future<void> _addChapter(BuildContext context) async {
    final courseId = widget.isEditMode ? widget.existingCourse!.id : 'temp';
    final result = await Navigator.push<ChapterEntity>(
      context,
      CupertinoPageRoute(
        builder: (context) => AddChapterPage(courseId: courseId),
      ),
    );

    if (result != null) {
      context.read<CoursesBloc>().add(AddChapterToNewCourseEvent(result));
    }
  }

  Future<void> _editChapter(
    BuildContext context,
    int index,
    ChapterEntity chapter,
  ) async {
    final courseId = widget.isEditMode ? widget.existingCourse!.id : 'temp';
    final result = await Navigator.push<ChapterEntity>(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            AddChapterPage(courseId: courseId, existingChapter: chapter),
      ),
    );

    if (result != null) {
      context.read<CoursesBloc>().add(
        UpdateChapterInNewCourseEvent(index, result),
      );
    }
  }

  void _removeChapter(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_chapter),
        content: Text(
          AppLocalizations.of(context)!.delete_chapter_confirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<CoursesBloc>().add(
                RemoveChapterFromNewCourseEvent(index),
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
