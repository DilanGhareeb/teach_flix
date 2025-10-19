import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:teach_flix/src/features/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/enroll_in_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_all_courses.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_course_by_id.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/create_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/upload_course_image.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/search_courses.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_courses_by_category.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/purchase_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_enrolled_courses.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/add_chapter_to_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/add_video_to_chapter.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/update_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/delete_course.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetAllCourses _getAllCourses;
  final GetCourseById _getCourseById;
  final CreateCourse _createCourse;
  final UploadCourseImage _uploadCourseImage;
  final SearchCourses _searchCourses;
  final GetCoursesByCategory _getCoursesByCategory;
  final PurchaseCourse _purchaseCourse;
  final GetEnrolledCourses _getEnrolledCourses;
  final EnrollInCourse _enrollInCourse;
  final AddChapterToCourse _addChapterToCourse;
  final AddVideoToChapter _addVideoToChapter;
  final UpdateCourse _updateCourse;
  final DeleteCourse _deleteCourse;

  final AuthBloc _authBloc;
  StreamSubscription<AuthState>? _authSubscription;

  CoursesBloc({
    required GetAllCourses getAllCourses,
    required GetCourseById getCourseById,
    required CreateCourse createCourse,
    required UploadCourseImage uploadCourseImage,
    required SearchCourses searchCourses,
    required GetCoursesByCategory getCoursesByCategory,
    required PurchaseCourse purchaseCourse,
    required EnrollInCourse enrollInCourse,
    required GetEnrolledCourses getEnrolledCourses,
    required AddChapterToCourse addChapterToCourse,
    required AddVideoToChapter addVideoToChapter,
    required UpdateCourse updateCourse,
    required DeleteCourse deleteCourse,
    required AuthBloc authBloc,
  }) : _getAllCourses = getAllCourses,
       _getCourseById = getCourseById,
       _createCourse = createCourse,
       _uploadCourseImage = uploadCourseImage,
       _searchCourses = searchCourses,
       _getCoursesByCategory = getCoursesByCategory,
       _purchaseCourse = purchaseCourse,
       _enrollInCourse = enrollInCourse,
       _getEnrolledCourses = getEnrolledCourses,
       _addChapterToCourse = addChapterToCourse,
       _addVideoToChapter = addVideoToChapter,
       _updateCourse = updateCourse,
       _deleteCourse = deleteCourse,
       _authBloc = authBloc,
       super(const CoursesState()) {
    on<LoadCoursesEvent>(_onLoadCourses);
    on<LoadCourseDetailEvent>(_onLoadCourseDetail);
    on<CreateCourseEvent>(_onCreateCourse);
    on<SearchCoursesEvent>(_onSearchCourses);
    on<LoadCoursesByCategoryEvent>(_onLoadCoursesByCategory);
    on<FilterCoursesByCategoryEvent>(_onFilterCoursesByCategory);
    on<PurchaseCourseEvent>(_onPurchaseCourse);
    on<EnrollInCourseEvent>(_onEnrollInCourse);
    on<LoadEnrolledCoursesEvent>(_onLoadEnrolledCourses);
    on<AddChapterToCourseEvent>(_onAddChapterToCourse);
    on<AddVideoToChapterEvent>(_onAddVideoToChapter);
    on<RefreshCoursesEvent>(_onRefreshCourses);
    on<PickImageFromGalleryEvent>(_onPickImageFromGallery);
    on<PickImageFromCameraEvent>(_onPickImageFromCamera);
    on<UploadCourseImageEvent>(_onUploadCourseImage);
    on<ClearSelectedImageEvent>(onClearSelectedImage);
    on<AddChapterToNewCourseEvent>(onAddChapterToNewCourse);
    on<RemoveChapterFromNewCourseEvent>(onRemoveChapterFromNewCourse);
    on<SubmitNewCourseEvent>(onSubmitNewCourse);
    on<UpdateChapterInNewCourseEvent>(onUpdateChapterInNewCourse);
    on<ReorderChaptersEvent>(onReorderChapters);
    on<ClearCourseCreationStateEvent>(onClearCourseCreationState);
    on<LoadExistingCourseForEditEvent>(onLoadExistingCourseForEdit);
    on<UpdateCourseEvent>(onUpdateCourse);
    on<DeleteCourseEvent>(onDeleteCourse);
    on<ClearCoursesDataEvent>(_onClearCoursesData);
    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState.status == AuthStatus.unauthenticated ||
          authState.status == AuthStatus.guest) {
        add(const ClearCoursesDataEvent());
      }
    });
  }

  void _onClearCoursesData(
    ClearCoursesDataEvent event,
    Emitter<CoursesState> emit,
  ) {
    emit(const CoursesState());
  }

  Future<void> _onLoadCourses(
    LoadCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, failure: null));
    final result = await _getAllCourses();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (courses) => emit(
        state.copyWith(
          status: CoursesStatus.loaded,
          courses: courses,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onLoadCourseDetail(
    LoadCourseDetailEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, failure: null));
    final result = await _getCourseById(
      params: GetCourseByIdParams(id: event.courseId),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (course) => emit(
        state.copyWith(
          status: CoursesStatus.courseDetailLoaded,
          selectedCourse: course,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onCreateCourse(
    CreateCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.creating, failure: null));
    final result = await _createCourse(
      params: CreateCourseParams(course: event.course),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (course) => emit(
        state.copyWith(
          status: CoursesStatus.courseCreated,
          selectedCourse: course,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onSearchCourses(
    SearchCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, failure: null));
    final result = await _searchCourses(
      params: SearchCoursesParams(query: event.query),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (courses) => emit(
        state.copyWith(
          status: CoursesStatus.loaded,
          courses: courses,
          searchQuery: event.query,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onLoadCoursesByCategory(
    LoadCoursesByCategoryEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, failure: null));
    final result = await _getCoursesByCategory(
      params: GetCoursesByCategoryParams(category: event.category),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (courses) => emit(
        state.copyWith(
          status: CoursesStatus.loaded,
          courses: courses,
          currentCategory: event.category,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onFilterCoursesByCategory(
    FilterCoursesByCategoryEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, failure: null));
    final result = await _getCoursesByCategory(
      params: GetCoursesByCategoryParams(category: event.category),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (courses) => emit(
        state.copyWith(
          status: CoursesStatus.loaded,
          courses: courses,
          currentCategory: event.category,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onPurchaseCourse(
    PurchaseCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.purchasing, failure: null));
    final result = await _purchaseCourse(
      params: PurchaseCourseParams(
        userId: event.userId,
        courseId: event.courseId,
      ),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (_) => emit(
        state.copyWith(status: CoursesStatus.coursePurchased, failure: null),
      ),
    );
  }

  Future<void> _onLoadEnrolledCourses(
    LoadEnrolledCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    // Don't emit loading state - just fetch silently
    final result = await _getEnrolledCourses(
      params: GetEnrolledCoursesParams(userId: event.userId),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (courses) => emit(
        state.copyWith(
          status: CoursesStatus.enrolledCoursesLoaded,
          enrolledCourses: courses,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onEnrollInCourse(
    EnrollInCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.purchasing, failure: null));
    final result = await _enrollInCourse(
      params: EnrollInCourseParams(
        userId: event.userId,
        courseId: event.courseId,
      ),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (_) => emit(
        state.copyWith(status: CoursesStatus.coursePurchased, failure: null),
      ),
    );
  }

  Future<void> _onAddChapterToCourse(
    AddChapterToCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.updating, failure: null));
    final result = await _addChapterToCourse(
      params: AddChapterToCourseParams(
        courseId: event.courseId,
        chapter: event.chapter,
      ),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (course) => emit(
        state.copyWith(
          status: CoursesStatus.courseUpdated,
          selectedCourse: course,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onAddVideoToChapter(
    AddVideoToChapterEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.updating, failure: null));
    final result = await _addVideoToChapter(
      params: AddVideoToChapterParams(
        courseId: event.courseId,
        chapterId: event.chapterId,
        video: event.video,
      ),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (course) => emit(
        state.copyWith(
          status: CoursesStatus.courseUpdated,
          selectedCourse: course,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onRefreshCourses(
    RefreshCoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, failure: null));
    final result = await _getAllCourses();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (courses) => emit(
        state.copyWith(
          status: CoursesStatus.loaded,
          courses: courses,
          failure: null,
        ),
      ),
    );
  }

  // New event handlers for course creation flow
  Future<void> _onPickImageFromGallery(
    PickImageFromGalleryEvent event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        emit(
          state.copyWith(
            status: CoursesStatus.imagePicked,
            selectedImage: File(pickedFile.path),
            failure: null,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          failure: UnknownFailure(),
        ),
      );
    }
  }

  Future<void> _onPickImageFromCamera(
    PickImageFromCameraEvent event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        emit(
          state.copyWith(
            status: CoursesStatus.imagePicked,
            selectedImage: File(pickedFile.path),
            failure: null,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          failure: UnknownFailure(),
        ),
      );
    }
  }

  Future<void> _onUploadCourseImage(
    UploadCourseImageEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CoursesStatus.imageUploading,
        imageUploadProgress: 0.0,
        failure: null,
      ),
    );
    final result = await _uploadCourseImage.call(
      params: UploadCourseImageParams(
        imageFile: event.imageFile,
        onProgress: (progress) {
          emit(
            state.copyWith(
              status: CoursesStatus.imageUploading,
              imageUploadProgress: progress,
            ),
          );
        },
      ),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (imageUrl) => emit(
        state.copyWith(
          status: CoursesStatus.imageUploaded,
          uploadedImageUrl: imageUrl,
          imageUploadProgress: 1.0,
          failure: null,
        ),
      ),
    );
  }

  void onClearSelectedImage(
    ClearSelectedImageEvent event,
    Emitter<CoursesState> emit,
  ) {
    emit(
      state.copyWith(
        status: CoursesStatus.initial,
        selectedImage: null,
        uploadedImageUrl: null,
        imageUploadProgress: 0.0,
        initialImageUrl: null, // NEW: Clear initial image too
        failure: null,
      ),
    );
  }

  void onAddChapterToNewCourse(
    AddChapterToNewCourseEvent event,
    Emitter<CoursesState> emit,
  ) {
    final updatedChapters = List<ChapterEntity>.from(state.chapters ?? [])
      ..add(event.chapter);
    emit(
      state.copyWith(
        status: CoursesStatus.chapterAdded,
        chapters: updatedChapters,
        failure: null,
      ),
    );
  }

  void onRemoveChapterFromNewCourse(
    RemoveChapterFromNewCourseEvent event,
    Emitter<CoursesState> emit,
  ) {
    final chapters = state.chapters ?? [];
    if (event.index >= 0 && event.index < chapters.length) {
      final updatedChapters = List<ChapterEntity>.from(chapters)
        ..removeAt(event.index);
      emit(
        state.copyWith(
          status: CoursesStatus.chapterRemoved,
          chapters: updatedChapters,
          failure: null,
        ),
      );
    }
  }

  void onUpdateChapterInNewCourse(
    UpdateChapterInNewCourseEvent event,
    Emitter<CoursesState> emit,
  ) {
    final currentChapters = List<ChapterEntity>.from(state.chapters ?? []);
    if (event.index >= 0 && event.index < currentChapters.length) {
      currentChapters[event.index] = event.updatedChapter;
      emit(
        state.copyWith(
          status: CoursesStatus.chapterAdded, // Reuse existing status
          chapters: currentChapters,
          failure: null,
        ),
      );
    }
  }

  void onReorderChapters(
    ReorderChaptersEvent event,
    Emitter<CoursesState> emit,
  ) {
    final currentChapters = List<ChapterEntity>.from(state.chapters ?? []);
    int newIndex = event.newIndex;
    if (newIndex > event.oldIndex) {
      newIndex -= 1;
    }
    final chapter = currentChapters.removeAt(event.oldIndex);
    currentChapters.insert(newIndex, chapter);
    emit(
      state.copyWith(
        status: CoursesStatus.chapterAdded, // Reuse existing status
        chapters: currentChapters,
        failure: null,
      ),
    );
  }

  void onClearCourseCreationState(
    ClearCourseCreationStateEvent event,
    Emitter<CoursesState> emit,
  ) {
    emit(
      state.copyWith(
        status: CoursesStatus.initial,
        clearImage: true,
        clearChapters: true,
        uploadedImageUrl: null,
        imageUploadProgress: 0.0,
        initialImageUrl: null, // NEW: Clear initial image URL
        failure: null,
      ),
    );
  }

  Future<void> onSubmitNewCourse(
    SubmitNewCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    print('DEBUG: Starting course submission');
    if (state.selectedImage == null) {
      print('DEBUG: No image selected');
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          failure: UnknownFailure(),
        ),
      );
      return;
    }

    print('DEBUG: Image selected, starting upload');
    emit(state.copyWith(status: CoursesStatus.creating, failure: null));

    final uploadResult = await _uploadCourseImage.call(
      params: UploadCourseImageParams(
        imageFile: state.selectedImage!,
        onProgress: (progress) {
          print(
            'DEBUG: Upload progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
      ),
    );

    final String? imageUrl = uploadResult.fold(
      (failure) {
        print('DEBUG: Upload failed - ${failure.runtimeType}');
        emit(state.copyWith(status: CoursesStatus.failure, failure: failure));
        return null;
      },
      (url) {
        print('DEBUG: Upload successful - $url');
        return url;
      },
    );

    if (imageUrl == null) {
      print('DEBUG: Image URL is null, stopping');
      return;
    }

    print('DEBUG: Creating course with imageUrl: $imageUrl');
    final course = CourseEntity(
      id: '',
      title: event.title,
      description: event.description,
      imageUrl: imageUrl,
      previewVideoUrl: event.previewVideoUrl,
      category: event.category,
      price: event.price,
      instructorId: event.instructorId,
      createAt: DateTime.now(),
      ratings: [],
      chapters: state.chapters ?? [],
    );

    final result = await _createCourse.call(
      params: CreateCourseParams(course: course),
    );

    result.fold(
      (failure) {
        print('DEBUG: Course creation failed - ${failure.runtimeType}');
        emit(state.copyWith(status: CoursesStatus.failure, failure: failure));
      },
      (createdCourse) {
        print('DEBUG: Course created successfully - ${createdCourse.id}');
        emit(
          state.copyWith(
            status: CoursesStatus.courseCreated,
            selectedCourse: createdCourse,
            selectedImage: null,
            uploadedImageUrl: null,
            chapters: null,
            failure: null,
          ),
        );
      },
    );
  }

  void onLoadExistingCourseForEdit(
    LoadExistingCourseForEditEvent event,
    Emitter<CoursesState> emit,
  ) {
    emit(
      state.copyWith(
        status: CoursesStatus.loadingForEdit,
        selectedCourse: event.course,
        initialImageUrl: event.course.imageUrl,
        chapters: event.course.chapters,
        selectedImage: null,
        uploadedImageUrl: null,
        imageUploadProgress: 0.0,
        failure: null,
      ),
    );
  }

  Future<void> onUpdateCourse(
    UpdateCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.updating, failure: null));

    String? finalImageUrl = state.initialImageUrl;

    if (event.newImageFile != null) {
      final uploadResult = await _uploadCourseImage.call(
        params: UploadCourseImageParams(
          imageFile: event.newImageFile!,
          onProgress: (progress) {
            emit(
              state.copyWith(
                status: CoursesStatus.imageUploading,
                imageUploadProgress: progress,
              ),
            );
          },
        ),
      );

      finalImageUrl = uploadResult.fold((failure) {
        emit(state.copyWith(status: CoursesStatus.failure, failure: failure));
        return null;
      }, (url) => url);

      if (finalImageUrl == null) {
        return;
      }
    } else if (state.uploadedImageUrl != null) {
      finalImageUrl = state.uploadedImageUrl;
    } else if (state.selectedImage != null) {
      final uploadResult = await _uploadCourseImage.call(
        params: UploadCourseImageParams(
          imageFile: state.selectedImage!,
          onProgress: (progress) {
            emit(
              state.copyWith(
                status: CoursesStatus.imageUploading,
                imageUploadProgress: progress,
              ),
            );
          },
        ),
      );

      finalImageUrl = uploadResult.fold((failure) {
        emit(state.copyWith(status: CoursesStatus.failure, failure: failure));
        return null;
      }, (url) => url);

      if (finalImageUrl == null) {
        return;
      }
    }

    if (finalImageUrl == null) {
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          failure: UnknownFailure(),
        ),
      );
      return;
    }

    final updatedCourse = CourseEntity(
      id: event.courseId,
      title: event.title,
      description: event.description,
      imageUrl: finalImageUrl,
      previewVideoUrl: event.previewVideoUrl,
      category: event.category,
      price: event.price,
      instructorId: event.instructorId,
      createAt:
          state.selectedCourse?.createAt ??
          DateTime.now(), // Preserve original creation date
      ratings: state.selectedCourse?.ratings ?? [], // Preserve existing ratings
      chapters: state.chapters ?? [], // Use current chapters in state
    );

    final result = await _updateCourse.call(
      UpdateCourseParams(course: updatedCourse),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (course) => emit(
        state.copyWith(
          status: CoursesStatus.courseUpdated,
          selectedCourse: course,
          selectedImage: null,
          uploadedImageUrl: null,
          initialImageUrl: null, // Clear initial image URL after update
          chapters: course.chapters,
          failure: null,
        ),
      ),
    );
  }

  Future<void> onDeleteCourse(
    DeleteCourseEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.deleting, failure: null));

    final result = await _deleteCourse.call(
      DeleteCourseParams(courseId: event.courseId),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: CoursesStatus.failure, failure: failure)),
      (_) => emit(
        state.copyWith(status: CoursesStatus.courseDeleted, failure: null),
      ),
    );
  }
}
