// lib/src/fatures/courses/presentation/bloc/courses_bloc.dart
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/get_all_courses.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/get_course_by_id.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/create_course.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/search_courses.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/get_courses_by_category.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/purchase_course.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/get_enrolled_courses.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/add_chapter_to_course.dart';
import 'package:teach_flix/src/fatures/courses/domain/usecases/add_video_to_chapter.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetAllCourses _getAllCourses;
  final GetCourseById _getCourseById;
  final CreateCourse _createCourse;
  final SearchCourses _searchCourses;
  final GetCoursesByCategory _getCoursesByCategory;
  final PurchaseCourse _purchaseCourse;
  final GetEnrolledCourses _getEnrolledCourses;
  final AddChapterToCourse _addChapterToCourse;
  final AddVideoToChapter _addVideoToChapter;

  CoursesBloc({
    required GetAllCourses getAllCourses,
    required GetCourseById getCourseById,
    required CreateCourse createCourse,
    required SearchCourses searchCourses,
    required GetCoursesByCategory getCoursesByCategory,
    required PurchaseCourse purchaseCourse,
    required GetEnrolledCourses getEnrolledCourses,
    required AddChapterToCourse addChapterToCourse,
    required AddVideoToChapter addVideoToChapter,
  }) : _getAllCourses = getAllCourses,
       _getCourseById = getCourseById,
       _createCourse = createCourse,
       _searchCourses = searchCourses,
       _getCoursesByCategory = getCoursesByCategory,
       _purchaseCourse = purchaseCourse,
       _getEnrolledCourses = getEnrolledCourses,
       _addChapterToCourse = addChapterToCourse,
       _addVideoToChapter = addVideoToChapter,
       super(CoursesInitial()) {
    on<LoadCoursesEvent>(_onLoadCourses);
    on<LoadCourseDetailEvent>(_onLoadCourseDetail);
    on<CreateCourseEvent>(_onCreateCourse);
    on<SearchCoursesEvent>(_onSearchCourses);
    on<LoadCoursesByCategoryEvent>(_onLoadCoursesByCategory);
    on<FilterCoursesByCategoryEvent>(_onFilterCoursesByCategory);
    on<PurchaseCourseEvent>(_onPurchaseCourse);
    on<LoadEnrolledCoursesEvent>(_onLoadEnrolledCourses);
    on<AddChapterToCourseEvent>(_onAddChapterToCourse);
    on<AddVideoToChapterEvent>(_onAddVideoToChapter);
    on<RefreshCoursesEvent>(_onRefreshCourses);
  }

  Future<void> _onLoadCourses(
    LoadCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());
    final result = await _getAllCourses();
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> _onLoadCourseDetail(
    LoadCourseDetailEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CourseDetailLoading());
    final result = await _getCourseById(
      params: GetCourseByIdParams(id: event.courseId),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (course) => emit(CourseDetailLoaded(course)),
    );
  }

  Future<void> _onCreateCourse(
    CreateCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CourseCreating());
    final result = await _createCourse(
      params: CreateCourseParams(course: event.course),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (course) => emit(CourseCreated(course)),
    );
  }

  Future<void> _onSearchCourses(
    SearchCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());
    final result = await _searchCourses(
      params: SearchCoursesParams(query: event.query),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (courses) => emit(CoursesLoaded(courses, searchQuery: event.query)),
    );
  }

  Future<void> _onLoadCoursesByCategory(
    LoadCoursesByCategoryEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());
    final result = await _getCoursesByCategory(
      params: GetCoursesByCategoryParams(category: event.category),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (courses) =>
          emit(CoursesLoaded(courses, currentCategory: event.category)),
    );
  }

  Future<void> _onFilterCoursesByCategory(
    FilterCoursesByCategoryEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());
    final result = await _getCoursesByCategory(
      params: GetCoursesByCategoryParams(category: event.category),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (courses) =>
          emit(CoursesLoaded(courses, currentCategory: event.category)),
    );
  }

  Future<void> _onPurchaseCourse(
    PurchaseCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursePurchasing());
    final result = await _purchaseCourse(
      params: PurchaseCourseParams(
        userId: event.userId,
        courseId: event.courseId,
      ),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (_) => emit(CoursePurchased()),
    );
  }

  Future<void> _onLoadEnrolledCourses(
    LoadEnrolledCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());
    final result = await _getEnrolledCourses(
      params: GetEnrolledCoursesParams(userId: event.userId),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> _onAddChapterToCourse(
    AddChapterToCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CourseUpdating());
    final result = await _addChapterToCourse(
      params: AddChapterToCourseParams(
        courseId: event.courseId,
        chapter: event.chapter,
      ),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (course) => emit(CourseUpdated(course)),
    );
  }

  Future<void> _onAddVideoToChapter(
    AddVideoToChapterEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CourseUpdating());
    final result = await _addVideoToChapter(
      params: AddVideoToChapterParams(
        courseId: event.courseId,
        chapterId: event.chapterId,
        video: event.video,
      ),
    );
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (course) => emit(CourseUpdated(course)),
    );
  }

  Future<void> _onRefreshCourses(
    RefreshCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(CoursesLoading());
    final result = await _getAllCourses();
    result.fold(
      (failure) => emit(CoursesError(failure.toString())),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }
}
