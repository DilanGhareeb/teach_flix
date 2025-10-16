enum CourseCategory {
  programming('Programming', 'پڕۆگرامسازی'),
  design('Design', 'دیزاین'),
  marketing('Marketing', 'مارکێتینگ'),
  business('Business', 'بازرگانی'),
  photography('Photography', 'وێنەگرتن'),
  music('Music', 'مۆسیقا'),
  language('Language', 'زمان'),
  fitness('Fitness', 'تەندروستی'),
  cooking('Cooking', 'چێشت لێنان'),
  science('Science', 'زانست'),
  mathematics('Mathematics', 'بیرکاری'),
  art('Art', 'هونەر');

  const CourseCategory(this.englishName, this.kurdishName);

  final String englishName;
  final String kurdishName;

  String getLocalizedName(String languageCode) {
    switch (languageCode) {
      case 'ckb':
        return kurdishName;
      default:
        return englishName;
    }
  }

  static CourseCategory fromString(String categoryName) {
    return CourseCategory.values.firstWhere(
      (category) =>
          category.englishName.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => CourseCategory.programming,
    );
  }

  static List<String> get allCategoryNames {
    return CourseCategory.values.map((e) => e.englishName).toList();
  }
}
