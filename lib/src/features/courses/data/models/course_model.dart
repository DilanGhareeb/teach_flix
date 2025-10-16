import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/data/models/chapter_model.dart';
import 'package:teach_flix/src/features/courses/data/models/course_rating_model.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.previewVideoUrl,
    required super.category,
    required super.price,
    required super.studentsEnrolled,
    required super.instructorId,
    required super.createAt,
    required super.ratings,
    required super.chapters,
  });

  // Add this factory method
  factory CourseModel.fromEntity(CourseEntity entity) {
    return CourseModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      previewVideoUrl: entity.previewVideoUrl,
      category: entity.category,
      price: entity.price,
      studentsEnrolled: entity.studentsEnrolled,
      instructorId: entity.instructorId,
      createAt: entity.createAt,
      ratings: entity.ratings,
      chapters: entity.chapters,
    );
  }

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
      previewVideoUrl: data['previewVideoUrl'] as String,
      category: data['category'] as String,
      price: (data['price'] as num).toDouble(),
      studentsEnrolled: data['studentsEnrolled'] as int?,
      instructorId: data['instructorId'] as String,
      createAt: (data['createAt'] as Timestamp).toDate(),
      ratings:
          (data['ratings'] as List<dynamic>?)
              ?.map(
                (rating) =>
                    CourseRatingModel.fromMap(rating as Map<String, dynamic>),
              )
              .toList() ??
          [],
      chapters:
          (data['chapters'] as List<dynamic>?)
              ?.map(
                (chapter) =>
                    ChapterModel.fromMap(chapter as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'titleLowercase': title.toLowerCase(),
      'description': description,
      'imageUrl': imageUrl,
      'previewVideoUrl': previewVideoUrl,
      'category': category,
      'price': price,
      'studentsEnrolled': studentsEnrolled,
      'instructorId': instructorId,
      'createAt': Timestamp.fromDate(createAt),
      'ratings': ratings
          .map((rating) => CourseRatingModel.fromEntity(rating).toMap())
          .toList(),
      'chapters': chapters
          .map((chapter) => ChapterModel.fromEntity(chapter).toMap())
          .toList(),
    };
  }
}
