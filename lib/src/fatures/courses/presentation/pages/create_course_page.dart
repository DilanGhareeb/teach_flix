import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
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
  final _imageUrlController = TextEditingController();
  final _previewVideoUrlController = TextEditingController();

  String _selectedCategory = 'Programming';

  final List<String> _categories = [
    'Programming',
    'Design',
    'Marketing',
    'Business',
    'Photography',
    'Music',
    'Language',
    'Fitness',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _previewVideoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.create_course), elevation: 0),
      body: BlocListener<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state is CourseCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.course_created_successfully),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is CoursesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: t.course_title,
                    hint: t.enter_course_title,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return t.title_required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _descriptionController,
                    label: t.description,
                    hint: t.enter_course_description,
                    maxLines: 4,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return t.description_required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: t.category,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

                  _buildTextField(
                    controller: _priceController,
                    label: t.price,
                    hint: t.enter_price,
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

                  _buildTextField(
                    controller: _imageUrlController,
                    label: t.course_image_url,
                    hint: t.enter_image_url,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return t.image_url_required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _previewVideoUrlController,
                    label: t.preview_video_url,
                    hint: t.enter_preview_video_url,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return t.preview_video_required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is CourseCreating ? null : _createCourse,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is CourseCreating
                          ? const CircularProgressIndicator()
                          : Text(
                              t.create_course,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  void _createCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      final authState = context.read<AuthBloc>().state;
      if (authState.user != null) {
        final course = CourseEntity(
          id: '', // Will be generated by Firebase
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: _imageUrlController.text,
          previewVideoUrl: _previewVideoUrlController.text,
          category: _selectedCategory,
          price: double.parse(_priceController.text),
          instructorId: authState.user!.id,
          createAt: DateTime.now(),
          ratings: [],
          chapters: [],
        );

        context.read<CoursesBloc>().add(CreateCourseEvent(course));
      }
    }
  }
}
