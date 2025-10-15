import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_category.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final bool showAllOption;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20), // Add padding here
        itemCount: (showAllOption ? 1 : 0) + CourseCategory.values.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 8), // Add spacing between chips
        itemBuilder: (context, index) {
          if (showAllOption && index == 0) {
            return _buildCategoryChip(
              context,
              t.all_categories,
              'all',
              selectedCategory == null || selectedCategory == 'all',
            );
          }

          final categoryIndex = showAllOption ? index - 1 : index;
          final category = CourseCategory.values[categoryIndex];

          return _buildCategoryChip(
            context,
            category.getLocalizedName(locale.languageCode),
            category.englishName,
            selectedCategory == category.englishName,
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    String value,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onCategorySelected(value),
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
