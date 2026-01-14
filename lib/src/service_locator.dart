import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/ai_assistnat/data/datasource/ai_chat_remote_data_source.dart';
import 'package:teach_flix/src/features/ai_assistnat/data/repository/ai_chat_repostiory_impl.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/clear_messages.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/create_chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/delete_chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/send_message.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/send_message_with_media.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/update_chat_session_title.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/watch_chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/watch_message.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/bloc/ai_chat_bloc.dart';

// Auth
import 'package:teach_flix/src/features/auth/data/datasources/auth_api_datasource.dart';
import 'package:teach_flix/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:teach_flix/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/deposit_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/get_user_by_id_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/send_reset_password_email.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/watch_user_profile_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/login_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/register_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/watch_auth_session.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/logout_usecase.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/withdraw_usecase.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/data/datasources/progress_firebase_datasource.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/add_rating_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/delete_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/delete_rating_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/enroll_in_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_top_rated_courses.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_user_all_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/get_user_rating_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/initialize_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/reset_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/toggle_quiz_completion_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/toggle_video_completion_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/update_course.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/update_rating_usecase.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/upload_course_image.dart';
import 'package:teach_flix/src/features/courses/domain/usecases/watch_progress_usecase.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/progress_bloc.dart';
import 'package:teach_flix/src/features/instructor_stats/data/datasources/instructor_stats_firebase_datasource.dart';
import 'package:teach_flix/src/features/instructor_stats/data/repositories/instructor_stats_repository_impl.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/repositories/instructor_stats_repository.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_course_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_instructor_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/get_instructor_transactions.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/usecases/watch_instructor_stats.dart';
import 'package:teach_flix/src/features/instructor_stats/presentation/bloc/instructor_stats_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/delete_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/start_conference.dart';
import 'package:teach_flix/src/features/quiz/data/datasource/quiz_firebase_datasource.dart';
import 'package:teach_flix/src/features/quiz/data/repository/quiz_repositroy_impl.dart';
import 'package:teach_flix/src/features/quiz/domain/repository/quiz_repository.dart';
import 'package:teach_flix/src/features/quiz/domain/usecases/get_quiz_by_id_usecase.dart';
import 'package:teach_flix/src/features/quiz/domain/usecases/get_quiz_result_usecase.dart';
import 'package:teach_flix/src/features/quiz/domain/usecases/submit_quiz_result_usecase.dart';
import 'package:teach_flix/src/features/quiz/view/bloc/quiz_bloc.dart';

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

import 'package:teach_flix/src/features/live_conference/data/datasources/live_conference_firebase_datasource.dart';
import 'package:teach_flix/src/features/live_conference/data/repositories/live_conference_repository_impl.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/create_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/end_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/get_all_active_conferences.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/get_conference_by_id.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/join_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/purchase_conference_access.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/watch_active_conferences.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';

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
  sl.registerFactory(() => SendPasswordResetEmail(sl()));
  sl.registerFactory(() => Withdraw(repository: sl()));
  sl.registerFactory(() => GetUserById(sl()));

  // : Register AuthBloc as singleton so it can be injected into CoursesBloc
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      watchAuthSession: sl(),
      getUserProfile: sl(),
      updateUserInfo: sl(),
      logoutUsecase: sl(),
      depositUsecase: sl(),
      sendPasswordResetEmail: sl(),
      withdrawUsecase: sl(),
      getUserById: sl(),
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

  sl.registerLazySingleton<ProgressFirebaseDataSource>(
    () => ProgressFirebaseDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      dataSource: sl<CourseFirebaseDataSource>(),
      progressDataSource: sl<ProgressFirebaseDataSource>(),
    ),
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
  sl.registerLazySingleton(() => AddRating(sl()));
  sl.registerLazySingleton(() => GetUserRating(sl()));
  sl.registerLazySingleton(() => UpdateRating(sl()));
  sl.registerLazySingleton(() => DeleteRating(sl()));
  sl.registerLazySingleton(() => GetTopRatedCourses(sl()));

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
      addRating: sl(),
      getUserRating: sl(),
      deleteRating: sl(),
      updateRating: sl(),
      getTopRatedCourses: sl(),
      authBloc: sl<AuthBloc>(),
    ),
  );

  sl.registerFactory(() => GetProgress(sl()));
  sl.registerFactory(() => WatchProgress(sl()));
  sl.registerFactory(() => ToggleVideoCompletion(sl()));
  sl.registerFactory(() => ToggleQuizCompletion(sl()));
  sl.registerFactory(() => InitializeProgress(sl()));
  sl.registerFactory(() => ResetProgress(sl()));
  sl.registerFactory(() => GetUserAllProgress(sl()));

  sl.registerFactory(
    () => ProgressBloc(
      getProgress: sl<GetProgress>(),
      watchProgress: sl<WatchProgress>(),
      toggleVideoCompletion: sl<ToggleVideoCompletion>(),
      toggleQuizCompletion: sl<ToggleQuizCompletion>(),
      initializeProgress: sl<InitializeProgress>(),
      resetProgress: sl<ResetProgress>(),
      getUserAllProgress: sl<GetUserAllProgress>(),
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

  sl.registerLazySingleton<GenerativeModel>(
    () => FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash'),
  );

  // Data sources
  sl.registerLazySingleton<AiChatRemoteDataSource>(
    () => AiChatRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      storage: sl<FirebaseStorage>(),
      geminiModel: sl<GenerativeModel>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AiChatRepository>(
    () => AiChatRepositoryImpl(remoteDataSource: sl<AiChatRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateChatSession(sl<AiChatRepository>()));
  sl.registerLazySingleton(() => WatchChatSessions(sl<AiChatRepository>()));
  sl.registerLazySingleton(() => WatchMessages(sl<AiChatRepository>()));
  sl.registerLazySingleton(() => SendMessage(sl<AiChatRepository>()));
  sl.registerLazySingleton(() => SendMessageWithMedia(sl<AiChatRepository>()));
  sl.registerLazySingleton(() => DeleteChatSession(sl<AiChatRepository>()));
  sl.registerLazySingleton(() => ClearMessages(sl<AiChatRepository>()));
  sl.registerLazySingleton(
    () => UpdateChatSessionTitle(sl<AiChatRepository>()),
  );

  // BLoC
  sl.registerFactory(
    () => AiChatBloc(
      createChatSession: sl<CreateChatSession>(),
      watchChatSessions: sl<WatchChatSessions>(),
      watchMessages: sl<WatchMessages>(),
      sendMessage: sl<SendMessage>(),
      sendMessageWithMedia: sl<SendMessageWithMedia>(),
      deleteChatSession: sl<DeleteChatSession>(),
      clearMessages: sl<ClearMessages>(),
      updateChatSessionTitle: sl<UpdateChatSessionTitle>(),
    ),
  );

  sl.registerLazySingleton<QuizFirebaseDataSource>(
    () => QuizFirebaseDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(dataSource: sl<QuizFirebaseDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetQuizByIdUseCase(repository: sl<QuizRepository>()),
  );
  sl.registerLazySingleton(
    () => SubmitQuizResultUseCase(repository: sl<QuizRepository>()),
  );
  sl.registerLazySingleton(
    () => GetQuizResultUseCase(repository: sl<QuizRepository>()),
  );

  sl.registerFactory(
    () => QuizBloc(
      getQuizByIdUseCase: sl<GetQuizByIdUseCase>(),
      submitQuizResultUseCase: sl<SubmitQuizResultUseCase>(),
      getQuizResultUseCase: sl<GetQuizResultUseCase>(),
      toggleQuizCompletion: sl<ToggleQuizCompletion>(),
    ),
  );

  sl.registerLazySingleton<LiveConferenceFirebaseDataSource>(
    () => LiveConferenceFirebaseDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<LiveConferenceRepository>(
    () => LiveConferenceRepositoryImpl(
      dataSource: sl<LiveConferenceFirebaseDataSource>(),
    ),
  );

  // ========== Live Conference feature - Use Cases ==========
  sl.registerFactory(() => CreateConference(sl()));
  sl.registerFactory(() => GetAllActiveConferences(sl()));
  sl.registerFactory(() => WatchActiveConferences(sl()));
  sl.registerFactory(() => GetConferenceById(sl()));
  sl.registerFactory(() => PurchaseConferenceAccess(sl()));
  sl.registerFactory(() => JoinConference(sl()));
  sl.registerFactory(() => EndConference(sl()));
  sl.registerFactory(() => StartConference(sl()));
  sl.registerFactory(() => DeleteConference(sl()));

  // ========== Live Conference feature - Bloc ==========
  sl.registerFactory(
    () => LiveConferenceBloc(
      getAllActiveConferences: sl<GetAllActiveConferences>(),
      watchActiveConferences: sl<WatchActiveConferences>(),
      createConference: sl<CreateConference>(),
      purchaseConferenceAccess: sl<PurchaseConferenceAccess>(),
      joinConference: sl<JoinConference>(),
      endConference: sl<EndConference>(),
      authBloc: sl<AuthBloc>(),
      startConference: sl<StartConference>(),
      deleteConference: sl<DeleteConference>(),
    ),
  );
}
