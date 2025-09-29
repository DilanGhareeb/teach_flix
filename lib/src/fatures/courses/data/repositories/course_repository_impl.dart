import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/fatures/courses/data/datasources/course_firebase_datasource.dart';
import 'package:teach_flix/src/fatures/courses/data/models/course_model.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseFirebaseDataSource dataSource;

  CourseRepositoryImpl({required this.dataSource});

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
}
