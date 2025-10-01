import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_category.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/add_chapter_page.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key});

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
    // Clear any previous course creation state when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursesBloc>().add(const ClearCourseCreationStateEvent());
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
      appBar: AppBar(title: Text(t.create_course), elevation: 0),
      body: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state.status == CoursesStatus.courseCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.course_created_successfully),
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
                          hint: t.enter_price,
                          icon: Icons.attach_money_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return t.price_required;
                            }
                            if (double.tryParse(value!) == null) {
                              return t.invalid_price;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Preview Video URL
                        _buildTextField(
                          controller: _previewVideoUrlController,
                          label: t.preview_video_url,
                          hint: t.enter_preview_video_url,
                          icon: Icons.video_library_rounded,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return t.preview_video_required;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // Chapters Section with Drag and Drop
                        _buildChaptersSection(context, state, colorScheme, t),

                        const SizedBox(height: 32),

                        // Create Course Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                state.status == CoursesStatus.creating ||
                                    state.status == CoursesStatus.imageUploading
                                ? null
                                : _createCourse,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: state.status == CoursesStatus.creating
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle_rounded),
                                      const SizedBox(width: 8),
                                      Text(
                                        t.create_course,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

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

  void _createCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      final state = context.read<CoursesBloc>().state;

      // Check if image is selected (not uploaded)
      if (state.selectedImage == null) {
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
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Future<void> _addChapter(BuildContext context) async {
    final result = await Navigator.push<ChapterEntity>(
      context,
      MaterialPageRoute(builder: (context) => AddChapterPage(courseId: 'temp')),
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
    final result = await Navigator.push<ChapterEntity>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddChapterPage(courseId: 'temp', existingChapter: chapter),
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
