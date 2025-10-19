part of 'courses_bloc.dart';

enum CoursesStatus {
  initial,
  loading,
  loaded,
  failure,
  creating,
  courseCreated,
  updating,
  courseUpdated,
  courseDetailLoaded,
  purchasing,
  coursePurchased,
  enrolledCoursesLoaded,
  imagePicked,
  imageUploading,
  imageUploaded,
  chapterAdded,
  chapterRemoved,
  loadingEnrolled,
  deleting,
  courseDeleted,
  loadingForEdit,
  ratingAdded,
  ratingUpdated,
  ratingDeleted,
}

class CoursesState extends Equatable {
  final CoursesStatus status;
  final List<CourseEntity>? courses;
  final List<CourseEntity>? enrolledCourses;
  final CourseEntity? selectedCourse;
  final String? searchQuery;
  final String? currentCategory;
  final Failure? failure;
  final File? selectedImage;
  final String? uploadedImageUrl;
  final double? imageUploadProgress;
  final List<ChapterEntity>? chapters;
  final List<CourseEntity>? topRatedCourses;
  final String? initialImageUrl;

  const CoursesState({
    this.status = CoursesStatus.initial,
    this.courses,
    this.enrolledCourses,
    this.selectedCourse,
    this.searchQuery,
    this.currentCategory,
    this.failure,
    this.selectedImage,
    this.uploadedImageUrl,
    this.imageUploadProgress,
    this.chapters,
    this.topRatedCourses,
    this.initialImageUrl,
  });

  CoursesState copyWith({
    CoursesStatus? status,
    List<CourseEntity>? courses,
    List<CourseEntity>? enrolledCourses,
    CourseEntity? selectedCourse,
    String? searchQuery,
    String? currentCategory,
    Failure? failure,
    File? selectedImage,
    String? uploadedImageUrl,
    double? imageUploadProgress,
    List<ChapterEntity>? chapters,
    List<CourseEntity>? topRatedCourses,
    bool clearImage = false,
    bool clearChapters = false,
    String? initialImageUrl,
  }) {
    return CoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      topRatedCourses: topRatedCourses ?? this.topRatedCourses,
      searchQuery: searchQuery ?? this.searchQuery,
      currentCategory: currentCategory ?? this.currentCategory,
      failure: failure,
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      imageUploadProgress: imageUploadProgress ?? this.imageUploadProgress,
      chapters: clearChapters ? [] : (chapters ?? this.chapters),
      initialImageUrl: initialImageUrl ?? this.initialImageUrl,
    );
  }

  @override
  List<Object?> get props => [
    status,
    courses,
    enrolledCourses,
    selectedCourse,
    searchQuery,
    currentCategory,
    failure,
    selectedImage,
    uploadedImageUrl,
    imageUploadProgress,
    topRatedCourses,
    chapters,
    initialImageUrl,
  ];
}
