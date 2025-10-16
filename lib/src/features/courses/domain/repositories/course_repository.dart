import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<CourseEntity>>> getAllCourses();
  Future<Either<Failure, CourseEntity>> getCourseById(String id);
  Future<Either<Failure, List<CourseEntity>>> getCoursesByCategory(
    String category,
  );
  Future<Either<Failure, List<CourseEntity>>> getCoursesByInstructor(
    String instructorId,
  );
  Future<Either<Failure, List<CourseEntity>>> getEnrolledCourses(String userId);
  Future<Either<Failure, CourseEntity>> createCourse(CourseEntity course);
  Future<Either<Failure, CourseEntity>> updateCourse(CourseEntity course);
  Future<Either<Failure, void>> deleteCourse(String id);
  Future<Either<Failure, List<CourseEntity>>> searchCourses(String query);
  Future<Either<Failure, void>> enrollInCourse(String userId, String courseId);
  Future<Either<Failure, bool>> isEnrolledInCourse(
    String userId,
    String courseId,
  );
  Future<Either<Failure, void>> purchaseCourse(String userId, String courseId);
  Stream<Either<Failure, List<CourseEntity>>> watchCoursesByInstructor(
    String instructorId,
  );
  Future<Either<Failure, String>> uploadCourseImage(
    File imageFile, {
    void Function(double progress)? onProgress,
  });
}
