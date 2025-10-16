import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class AddChapterToCourse
    implements Usecase<AddChapterToCourseParams, CourseEntity> {
  final CourseRepository repository;

  AddChapterToCourse(this.repository);

  @override
  Future<Either<Failure, CourseEntity>> call({
    required AddChapterToCourseParams params,
  }) async {
    // Get the existing course
    final courseResult = await repository.getCourseById(params.courseId);

    return courseResult.fold((failure) => Left(failure), (course) async {
      // Add the new chapter
      final updatedChapters = List<ChapterEntity>.from(course.chapters)
        ..add(params.chapter);

      final updatedCourse = CourseEntity(
        id: course.id,
        title: course.title,
        description: course.description,
        imageUrl: course.imageUrl,
        previewVideoUrl: course.previewVideoUrl,
        category: course.category,
        price: course.price,
        instructorId: course.instructorId,
        createAt: course.createAt,
        ratings: course.ratings,
        chapters: updatedChapters,
      );

      return await repository.updateCourse(updatedCourse);
    });
  }
}

class AddChapterToCourseParams extends Equatable {
  final String courseId;
  final ChapterEntity chapter;

  const AddChapterToCourseParams({
    required this.courseId,
    required this.chapter,
  });

  @override
  List<Object> get props => [courseId, chapter];
}
