import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_category.dart';

class CategoryGrid extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoryGrid({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: CourseCategory.values.length,
      itemBuilder: (context, index) {
        final category = CourseCategory.values[index];
        return _CategoryCard(
          category: category,
          locale: locale.languageCode,
          onTap: () => onCategorySelected(category.englishName),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CourseCategory category;
  final String locale;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: _getCategoryColors(category),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Icon(_getCategoryIcon(category), color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.getLocalizedName(locale),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getCategoryColors(CourseCategory category) {
    switch (category) {
      case CourseCategory.programming:
        return [Colors.blue[600]!, Colors.blue[800]!];
      case CourseCategory.design:
        return [Colors.purple[600]!, Colors.purple[800]!];
      case CourseCategory.marketing:
        return [Colors.orange[600]!, Colors.orange[800]!];
      case CourseCategory.business:
        return [Colors.green[600]!, Colors.green[800]!];
      case CourseCategory.photography:
        return [Colors.pink[600]!, Colors.pink[800]!];
      case CourseCategory.music:
        return [Colors.indigo[600]!, Colors.indigo[800]!];
      case CourseCategory.language:
        return [Colors.teal[600]!, Colors.teal[800]!];
      case CourseCategory.fitness:
        return [Colors.red[600]!, Colors.red[800]!];
      case CourseCategory.cooking:
        return [Colors.amber[600]!, Colors.amber[800]!];
      case CourseCategory.science:
        return [Colors.cyan[600]!, Colors.cyan[800]!];
      case CourseCategory.mathematics:
        return [Colors.deepPurple[600]!, Colors.deepPurple[800]!];
      case CourseCategory.art:
        return [Colors.brown[600]!, Colors.brown[800]!];
    }
  }

  IconData _getCategoryIcon(CourseCategory category) {
    switch (category) {
      case CourseCategory.programming:
        return Icons.code;
      case CourseCategory.design:
        return Icons.design_services;
      case CourseCategory.marketing:
        return Icons.campaign;
      case CourseCategory.business:
        return Icons.business;
      case CourseCategory.photography:
        return Icons.camera_alt;
      case CourseCategory.music:
        return Icons.music_note;
      case CourseCategory.language:
        return Icons.language;
      case CourseCategory.fitness:
        return Icons.fitness_center;
      case CourseCategory.cooking:
        return Icons.restaurant;
      case CourseCategory.science:
        return Icons.science;
      case CourseCategory.mathematics:
        return Icons.calculate;
      case CourseCategory.art:
        return Icons.palette;
    }
  }
}
