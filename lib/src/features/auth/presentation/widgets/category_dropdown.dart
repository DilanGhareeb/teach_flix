import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_category.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CategoryDropdown extends StatelessWidget {
  final CourseCategory? selectedCategory;
  final String languageCode;
  final bool isEnabled;
  final ValueChanged<CourseCategory?> onChanged;
  final FormFieldValidator<CourseCategory>? validator;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.languageCode,
    required this.isEnabled,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<CourseCategory>(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          prefixIcon: Icon(
            Icons.local_library_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
        hint: Text(AppLocalizations.of(context)!.select_category),
        items: CourseCategory.values
            .map(
              (category) => DropdownMenuItem(
                value: category,
                child: Text(category.getLocalizedName(languageCode)),
              ),
            )
            .toList(),
        initialValue: selectedCategory,
        validator: validator,
        onChanged: isEnabled ? onChanged : null,
        borderRadius: BorderRadius.circular(16),
        dropdownColor: theme.colorScheme.surface,
        icon: const Icon(Icons.arrow_drop_down_rounded),
      ),
    );
  }
}
