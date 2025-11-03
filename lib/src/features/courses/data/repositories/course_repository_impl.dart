import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/data/datasources/course_firebase_datasource.dart';
import 'package:teach_flix/src/features/courses/data/datasources/progress_firebase_datasource.dart';
import 'package:teach_flix/src/features/courses/data/models/course_model.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_rating_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/student_progress_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseFirebaseDataSource dataSource;
  final ProgressFirebaseDataSource progressDataSource;

  CourseRepositoryImpl({
    required this.dataSource,
    required this.progressDataSource,
  });

  @override
  Future<Either<Failure, List<CourseEntity>>> getAllCourses() async {
    return await dataSource.getAllCourses();
  }

  @override
  Future<Either<Failure, CourseEntity>> getCourseById(String id) async {
    return await dataSource.getCourseById(id);
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getCoursesByCategory(
    String category,
  ) async {
    return await dataSource.getCoursesByCategory(category);
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getCoursesByInstructor(
    String instructorId,
  ) async {
    return await dataSource.getCoursesByInstructor(instructorId);
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getEnrolledCourses(
    String userId,
  ) async {
    return await dataSource.getEnrolledCourses(userId);
  }

  @override
  Future<Either<Failure, CourseEntity>> createCourse(
    CourseEntity course,
  ) async {
    final courseModel = CourseModel.fromEntity(course);
    return await dataSource.createCourse(courseModel);
  }

  @override
  Future<Either<Failure, CourseEntity>> updateCourse(
    CourseEntity course,
  ) async {
    final courseModel = CourseModel.fromEntity(course);
    return await dataSource.updateCourse(courseModel);
  }

  @override
  Future<Either<Failure, void>> deleteCourse(String id) async {
    return await dataSource.deleteCourse(id);
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> searchCourses(
    String query,
  ) async {
    return await dataSource.searchCourses(query);
  }

  @override
  Future<Either<Failure, void>> enrollInCourse(
    String userId,
    String courseId,
  ) async {
    return await dataSource.enrollInCourse(userId, courseId);
  }

  @override
  Future<Either<Failure, bool>> isEnrolledInCourse(
    String userId,
    String courseId,
  ) async {
    return await dataSource.isEnrolledInCourse(userId, courseId);
  }

  @override
  Future<Either<Failure, void>> purchaseCourse(
    String userId,
    String courseId,
  ) async {
    return await dataSource.purchaseCourse(userId, courseId);
  }

  @override
  Stream<Either<Failure, List<CourseEntity>>> watchCoursesByInstructor(
    String instructorId,
  ) {
    return dataSource.watchCoursesByInstructor(instructorId);
  }

  @override
  Future<Either<Failure, String>> uploadCourseImage(
    File imageFile, {
    void Function(double progress)? onProgress,
  }) async {
    return await dataSource.uploadImage(imageFile, onProgress: onProgress);
  }

  @override
  Future<Either<Failure, void>> addRating({
    required String userId,
    required String courseId,
    required double rating,
    required String comment,
  }) async {
    return await dataSource.addRating(
      userId: userId,
      courseId: courseId,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<Either<Failure, void>> updateRating({
    required String ratingId,
    required double rating,
    required String comment,
  }) async {
    return await dataSource.updateRating(
      ratingId: ratingId,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getTopRatedCourses({
    int limit = 3,
  }) async {
    try {
      final result = await dataSource.getTopRatedCourses(limit: limit);
      return result.fold(
        (failure) => Left(failure),
        (courseModels) => Right(courseModels.map((model) => model).toList()),
      );
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRating(String ratingId) async {
    return await dataSource.deleteRating(ratingId);
  }

  @override
  Future<Either<Failure, CourseRatingEntity?>> getUserRatingForCourse({
    required String userId,
    required String courseId,
  }) async {
    return await dataSource.getUserRatingForCourse(
      userId: userId,
      courseId: courseId,
    );
  }

  @override
  Future<Either<Failure, StudentProgressEntity>> getProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      final progress = await progressDataSource.getProgress(
        userId: userId,
        courseId: courseId,
      );
      return Right(progress);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, StudentProgressEntity>> watchProgress({
    required String userId,
    required String courseId,
  }) {
    try {
      return progressDataSource
          .watchProgress(userId: userId, courseId: courseId)
          .map((progress) => Right<Failure, StudentProgressEntity>(progress))
          .handleError(
            (error) => Left<Failure, StudentProgressEntity>(
              ServerFailure(code: error.toString()),
            ),
          );
    } catch (e) {
      return Stream.value(Left(ServerFailure(code: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> markVideoAsCompleted({
    required String userId,
    required String courseId,
    required String videoId,
  }) async {
    try {
      await progressDataSource.markVideoAsCompleted(
        userId: userId,
        courseId: courseId,
        videoId: videoId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markVideoAsUncompleted({
    required String userId,
    required String courseId,
    required String videoId,
  }) async {
    try {
      await progressDataSource.markVideoAsUncompleted(
        userId: userId,
        courseId: courseId,
        videoId: videoId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markQuizAsCompleted({
    required String userId,
    required String courseId,
    required String quizId,
  }) async {
    try {
      await progressDataSource.markQuizAsCompleted(
        userId: userId,
        courseId: courseId,
        quizId: quizId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markQuizAsUncompleted({
    required String userId,
    required String courseId,
    required String quizId,
  }) async {
    try {
      await progressDataSource.markQuizAsUncompleted(
        userId: userId,
        courseId: courseId,
        quizId: quizId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProgressPercentage({
    required String userId,
    required String courseId,
    required int totalItems,
  }) async {
    try {
      await progressDataSource.updateProgressPercentage(
        userId: userId,
        courseId: courseId,
        totalItems: totalItems,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudentProgressEntity>>> getUserAllProgress({
    required String userId,
  }) async {
    try {
      final progressList = await progressDataSource.getUserAllProgress(
        userId: userId,
      );
      return Right(progressList);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StudentProgressEntity>> initializeProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      final progress = await progressDataSource.initializeProgress(
        userId: userId,
        courseId: courseId,
      );
      return Right(progress);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      await progressDataSource.resetProgress(
        userId: userId,
        courseId: courseId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }
}
