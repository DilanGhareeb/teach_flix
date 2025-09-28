import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/repositories/course_repository.dart';

class AddVideoToChapter
    implements Usecase<AddVideoToChapterParams, CourseEntity> {
  final CourseRepository repository;

  AddVideoToChapter(this.repository);

  @override
  Future<Either<Failure, CourseEntity>> call({
    required AddVideoToChapterParams params,
  }) async {
    final courseResult = await repository.getCourseById(params.courseId);

    return courseResult.fold((failure) => Left(failure), (course) async {
      // Find the chapter and add the video
      final updatedChapters = course.chapters.map((chapter) {
        if (chapter.id == params.chapterId) {
          final updatedVideos = List<VideoEntity>.from(chapter.videosUrls)
            ..add(params.video);

          return ChapterEntity(
            id: chapter.id,
            title: chapter.title,
            videosUrls: updatedVideos,
            quizzes: chapter.quizzes,
          );
        }
        return chapter;
      }).toList();

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

class AddVideoToChapterParams extends Equatable {
  final String courseId;
  final String chapterId;
  final VideoEntity video;

  const AddVideoToChapterParams({
    required this.courseId,
    required this.chapterId,
    required this.video,
  });

  @override
  List<Object> get props => [courseId, chapterId, video];
}
