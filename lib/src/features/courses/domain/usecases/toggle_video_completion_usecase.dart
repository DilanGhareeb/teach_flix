import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/courses/domain/repositories/course_repository.dart';

class ToggleVideoCompletion {
  final CourseRepository repository;

  ToggleVideoCompletion(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String courseId,
    required String videoId,
    required bool isCompleted,
    required int totalItems,
  }) async {
    if (isCompleted) {
      // Mark as completed
      final result = await repository.markVideoAsCompleted(
        userId: userId,
        courseId: courseId,
        videoId: videoId,
      );

      return result.fold((failure) => Left(failure), (_) async {
        // Update progress percentage
        await repository.updateProgressPercentage(
          userId: userId,
          courseId: courseId,
          totalItems: totalItems,
        );
        return const Right(null);
      });
    } else {
      // Mark as uncompleted
      final result = await repository.markVideoAsUncompleted(
        userId: userId,
        courseId: courseId,
        videoId: videoId,
      );

      return result.fold((failure) => Left(failure), (_) async {
        // Update progress percentage
        await repository.updateProgressPercentage(
          userId: userId,
          courseId: courseId,
          totalItems: totalItems,
        );
        return const Right(null);
      });
    }
  }
}
