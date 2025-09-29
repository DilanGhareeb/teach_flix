part of 'courses_bloc.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();
  @override
  List<Object?> get props => [];
}

class LoadCoursesEvent extends CoursesEvent {
  const LoadCoursesEvent();
}

class LoadCourseDetailEvent extends CoursesEvent {
  final String courseId;
  const LoadCourseDetailEvent(this.courseId);
  @override
  List<Object> get props => [courseId];
}

class CreateCourseEvent extends CoursesEvent {
  final CourseEntity course;
  const CreateCourseEvent(this.course);
  @override
  List<Object> get props => [course];
}

class SearchCoursesEvent extends CoursesEvent {
  final String query;
  const SearchCoursesEvent(this.query);
  @override
  List<Object> get props => [query];
}

class LoadCoursesByCategoryEvent extends CoursesEvent {
  final String category;
  const LoadCoursesByCategoryEvent(this.category);
  @override
  List<Object> get props => [category];
}

class FilterCoursesByCategoryEvent extends CoursesEvent {
  final String category;
  const FilterCoursesByCategoryEvent(this.category);
  @override
  List<Object> get props => [category];
}

class PurchaseCourseEvent extends CoursesEvent {
  final String userId;
  final String courseId;
  const PurchaseCourseEvent({required this.userId, required this.courseId});
  @override
  List<Object> get props => [userId, courseId];
}

class LoadEnrolledCoursesEvent extends CoursesEvent {
  final String userId;
  const LoadEnrolledCoursesEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

class AddChapterToCourseEvent extends CoursesEvent {
  final String courseId;
  final ChapterEntity chapter;
  const AddChapterToCourseEvent({
    required this.courseId,
    required this.chapter,
  });
  @override
  List<Object> get props => [courseId, chapter];
}

class AddVideoToChapterEvent extends CoursesEvent {
  final String courseId;
  final String chapterId;
  final VideoEntity video;
  const AddVideoToChapterEvent({
    required this.courseId,
    required this.chapterId,
    required this.video,
  });
  @override
  List<Object> get props => [courseId, chapterId, video];
}

class RefreshCoursesEvent extends CoursesEvent {
  const RefreshCoursesEvent();
}

// New events for image upload and course creation
class PickImageFromGalleryEvent extends CoursesEvent {
  const PickImageFromGalleryEvent();
}

class PickImageFromCameraEvent extends CoursesEvent {
  const PickImageFromCameraEvent();
}

class UploadCourseImageEvent extends CoursesEvent {
  final File imageFile;
  const UploadCourseImageEvent(this.imageFile);
  @override
  List<Object> get props => [imageFile];
}

class ClearSelectedImageEvent extends CoursesEvent {
  const ClearSelectedImageEvent();
}

class AddChapterToNewCourseEvent extends CoursesEvent {
  final ChapterEntity chapter;
  const AddChapterToNewCourseEvent(this.chapter);
  @override
  List<Object> get props => [chapter];
}

class RemoveChapterFromNewCourseEvent extends CoursesEvent {
  final int index;
  const RemoveChapterFromNewCourseEvent(this.index);
  @override
  List<Object> get props => [index];
}

class SubmitNewCourseEvent extends CoursesEvent {
  final String title;
  final String description;
  final String category;
  final double price;
  final String previewVideoUrl;
  final String instructorId;

  const SubmitNewCourseEvent({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.previewVideoUrl,
    required this.instructorId,
  });

  @override
  List<Object> get props => [
    title,
    description,
    category,
    price,
    previewVideoUrl,
    instructorId,
  ];
}
