// lib/src/service_locator.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth
import 'package:teach_flix/src/features/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:teach_flix/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/deposit_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/watch_user_profile_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/watch_auth_session.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/logout_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/withdraw_usecase.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/delete_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/enroll_in_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/update_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/upload_course_image.dart';
import 'package:teach_flix/src/features/instructor_stats/data/datasources/instructor_stats_firebase_datasource.dart';
import 'package:teach_flix/src/features/instructor_stats/data/repositories/instructor_stats_repository_impl.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/repositories/instructor_stats_repository.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_course_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_instructor_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_instructor_transactions.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/watch_instructor_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/presentation/bloc/instructor_stats_bloc.dart';

// Settings
import 'package:teach_flix/src/features/settings/data/datasources/app_prefernce_local.dart';
import 'package:teach_flix/src/features/settings/data/repositories/app_preference_repository_impl.dart';
import 'package:teach_flix/src/features/settings/domain/repositories/app_preference_repository.dart';
import 'package:teach_flix/src/features/settings/domain/usecases/change_language_code.dart';
import 'package:teach_flix/src/features/settings/domain/usecases/change_theme_usecase.dart';
import 'package:teach_flix/src/features/settings/domain/usecases/get_language_code.dart';
import 'package:teach_flix/src/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:teach_flix/src/features/settings/presentation/bloc/settings_bloc.dart';

// Courses - Data Layer
import 'package:teach_flix/src/features/courses/data/datasources/course_firebase_datasource.dart';
import 'package:teach_flix/src/features/courses/data/repositories/course_repository_impl.dart';

// Courses - Domain Layer
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/add_chapter_to_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/add_video_to_chapter.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/create_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_all_courses.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_course_by_id.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_courses_by_category.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_enrolled_courses.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/purchase_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/search_courses.dart';

// Courses - Presentation Layer
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ========== Firebase instances ==========
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  // ========== Auth feature ==========
  sl.registerLazySingleton<AuthApiDatasource>(
    () => AuthApiDatasourceImpl(
      fireStore: sl<FirebaseFirestore>(),
      fireAuth: sl<FirebaseAuth>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authApiDatasource: sl()),
  );
  sl.registerFactory(() => WatchAuthSession(repository: sl()));
  sl.registerFactory(() => WatchUserProfile(repository: sl()));
  sl.registerFactory(() => Login(repository: sl()));
  sl.registerFactory(() => Register(repository: sl()));
  sl.registerFactory(() => UpdateUserInfo(sl()));
  sl.registerFactory(() => Logout(repository: sl()));
  sl.registerFactory(() => Deposit(repository: sl()));
  sl.registerFactory(() => Withdraw(repository: sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      watchAuthSession: sl(),
      getUserProfile: sl(),
      updateUserInfo: sl(),
      logoutUsecase: sl(),
      depositUsecase: sl(),
      withdrawUsecase: sl(),
    ),
  );

  // ========== SharedPreferences ==========
  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });

  await sl.isReady<SharedPreferences>();

  // ========== Settings feature ==========
  sl.registerLazySingleton<AppPreferenceLocal>(
    () => AppPreferenceLocalImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AppPreferenceRepository>(
    () => AppPreferenceRepositoryImpl(sl<AppPreferenceLocal>()),
  );

  sl.registerFactory(() => GetLanguageCode(sl<AppPreferenceRepository>()));
  sl.registerFactory(() => GetTheme(sl<AppPreferenceRepository>()));
  sl.registerFactory(() => ChangeLanguageCode(sl<AppPreferenceRepository>()));
  sl.registerFactory(() => ChangeTheme(sl<AppPreferenceRepository>()));

  sl.registerFactory(
    () => SettingsBloc(
      getLanguageCode: sl(),
      getTheme: sl(),
      changeLanguageCode: sl(),
      changeTheme: sl(),
    ),
  );

  // ========== Courses feature - Data Layer ==========
  sl.registerLazySingleton<CourseFirebaseDataSource>(
    () => CourseFirebaseDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      storage: sl<FirebaseStorage>(),
    ),
  );

  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(dataSource: sl<CourseFirebaseDataSource>()),
  );

  // ========== Courses feature - Use Cases ==========
  sl.registerFactory(() => AddChapterToCourse(sl()));
  sl.registerFactory(() => AddVideoToChapter(sl()));
  sl.registerFactory(() => CreateCourse(sl()));
  sl.registerFactory(() => GetAllCourses(sl()));
  sl.registerFactory(() => GetCourseById(sl()));
  sl.registerFactory(() => GetCoursesByCategory(sl()));
  sl.registerFactory(() => UploadCourseImage(sl()));
  sl.registerFactory(() => GetEnrolledCourses(sl()));
  sl.registerFactory(() => PurchaseCourse(sl()));
  sl.registerFactory(() => EnrollInCourse(sl()));
  sl.registerFactory(() => SearchCourses(sl()));
  sl.registerFactory(() => UpdateCourse(sl()));
  sl.registerFactory(() => DeleteCourse(sl()));

  // ========== Courses feature - Bloc ==========
  sl.registerFactory(
    () => CoursesBloc(
      getAllCourses: sl(),
      getCoursesByCategory: sl(),
      searchCourses: sl(),
      getCourseById: sl(),
      enrollInCourse: sl(),
      getEnrolledCourses: sl(),
      createCourse: sl(),
      addChapterToCourse: sl(),
      addVideoToChapter: sl(),
      purchaseCourse: sl(),
      uploadCourseImage: sl(),
      updateCourse: sl(),
      deleteCourse: sl(),
    ),
  );

  // ========== Instructor Stats feature - Data Layer ==========
  sl.registerLazySingleton<InstructorStatsFirebaseDataSource>(
    () => InstructorStatsFirebaseDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<InstructorStatsRepository>(
    () =>
        InstructorStatsRepositoryImpl(sl<InstructorStatsFirebaseDataSource>()),
  );

  // ========== Instructor Stats feature - Use Cases ==========
  sl.registerFactory(() => GetInstructorStats(sl<InstructorStatsRepository>()));
  sl.registerFactory(() => GetCourseStats(sl<InstructorStatsRepository>()));
  sl.registerFactory(
    () => GetInstructorTransactions(sl<InstructorStatsRepository>()),
  );
  sl.registerFactory(
    () => WatchInstructorStats(sl<InstructorStatsRepository>()),
  );

  // ========== Instructor Stats feature - Bloc ==========
  sl.registerFactory(
    () => InstructorStatsBloc(
      getInstructorStats: sl<GetInstructorStats>(),
      getCourseStats: sl<GetCourseStats>(),
      getInstructorTransactions: sl<GetInstructorTransactions>(),
      watchInstructorStats: sl<WatchInstructorStats>(),
    ),
  );
}
