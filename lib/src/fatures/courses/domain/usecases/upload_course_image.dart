import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/courses/domain/repositories/course_repository.dart';

class UploadCourseImage implements Usecase<UploadCourseImageParams, String> {
  final CourseRepository repository;

  UploadCourseImage(this.repository);

  @override
  Future<Either<Failure, String>> call({
    required UploadCourseImageParams params,
  }) async {
    return await repository.uploadCourseImage(
      params.imageFile,
      onProgress: params.onProgress,
    );
  }
}

class UploadCourseImageParams extends Equatable {
  final File imageFile;
  final void Function(double progress)? onProgress;

  const UploadCourseImageParams({required this.imageFile, this.onProgress});

  @override
  List<Object?> get props => [imageFile, onProgress];
}
