import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_rating_entity.dart';

class CourseEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String previewVideoUrl;
  final String category;
  final double price;
  final String instructorId;
  final DateTime createAt;
  final List<CourseRatingEntity> ratings;
  final List<ChapterEntity> chapters;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.previewVideoUrl,
    required this.category,
    required this.price,
    required this.instructorId,
    required this.createAt,
    required this.ratings,
    required this.chapters,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    previewVideoUrl,
    category,
    price,
    instructorId,
    createAt,
    ratings,
    chapters,
  ];
}
