part of 'courses_bloc.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();
  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {
  const CoursesInitial();
}

class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

class CoursesLoaded extends CoursesState {
  final List<CourseEntity> courses;
  final String? currentCategory;
  final String? searchQuery;

  const CoursesLoaded(this.courses, {this.currentCategory, this.searchQuery});

  @override
  List<Object?> get props => [courses, currentCategory, searchQuery];

  CoursesLoaded copyWith({
    List<CourseEntity>? courses,
    String? currentCategory,
    String? searchQuery,
  }) {
    return CoursesLoaded(
      courses ?? this.courses,
      currentCategory: currentCategory ?? this.currentCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CoursesError extends CoursesState {
  final String message;
  const CoursesError(this.message);
  @override
  List<Object> get props => [message];
}

class CourseDetailLoading extends CoursesState {
  const CourseDetailLoading();
}

class CourseDetailLoaded extends CoursesState {
  final CourseEntity course;
  const CourseDetailLoaded(this.course);
  @override
  List<Object> get props => [course];
}

class CourseCreating extends CoursesState {
  const CourseCreating();
}

class CourseCreated extends CoursesState {
  final CourseEntity course;
  const CourseCreated(this.course);
  @override
  List<Object> get props => [course];
}

class CoursePurchasing extends CoursesState {
  const CoursePurchasing();
}

class CoursePurchased extends CoursesState {
  const CoursePurchased();
}

class CourseUpdating extends CoursesState {
  const CourseUpdating();
}

class CourseUpdated extends CoursesState {
  final CourseEntity course;
  const CourseUpdated(this.course);
  @override
  List<Object> get props => [course];
}
