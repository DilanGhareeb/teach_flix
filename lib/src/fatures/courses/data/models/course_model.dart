import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/fatures/courses/data/models/course_rating_model.dart';
import 'package:teach_flix/src/fatures/courses/data/models/chapter_model.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.previewVideoUrl,
    required super.category,
    required super.price,
    required super.instructorId,
    required super.createAt,
    required super.ratings,
    required super.chapters,
  });

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      previewVideoUrl: data['previewVideoUrl'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      instructorId: data['instructorId'] ?? '',
      createAt: (data['createAt'] as Timestamp).toDate(),
      ratings: (data['ratings'] as List<dynamic>? ?? [])
          .map((rating) => CourseRatingModel.fromMap(rating))
          .toList(),
      chapters: (data['chapters'] as List<dynamic>? ?? [])
          .map((chapter) => ChapterModel.fromMap(chapter))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'previewVideoUrl': previewVideoUrl,
      'category': category,
      'price': price,
      'instructorId': instructorId,
      'createAt': Timestamp.fromDate(createAt),
      'ratings': ratings
          .map((rating) => (rating as CourseRatingModel).toMap())
          .toList(),
      'chapters': chapters
          .map((chapter) => (chapter as ChapterModel).toMap())
          .toList(),
    };
  }

  factory CourseModel.fromEntity(CourseEntity entity) {
    return CourseModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      previewVideoUrl: entity.previewVideoUrl,
      category: entity.category,
      price: entity.price,
      instructorId: entity.instructorId,
      createAt: entity.createAt,
      ratings: entity.ratings,
      chapters: entity.chapters,
    );
  }
}
