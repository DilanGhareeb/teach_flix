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

  static Future<CourseModel> fromFirestore(
    DocumentSnapshot doc,
    FirebaseFirestore firestore,
  ) async {
    final data = doc.data() as Map<String, dynamic>;

    // Fetch ratings from separate collection
    final ratingsSnapshot = await firestore
        .collection('ratings')
        .where('courseId', isEqualTo: doc.id)
        .get();

    final ratings = ratingsSnapshot.docs
        .map((ratingDoc) => CourseRatingModel.fromFirestore(ratingDoc))
        .toList();

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
      ratings: ratings,
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
      // Don't store ratings in course document
      'chapters': chapters
          .map((chapter) => ChapterModel.fromEntity(chapter).toMap())
          .toList(),
    };
  }
}
