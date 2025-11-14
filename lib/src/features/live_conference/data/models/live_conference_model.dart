import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';

class LiveConferenceModel extends LiveConference {
  const LiveConferenceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.instructorId,
    required super.instructorName,
    required super.price,
    required super.scheduledStartTime,
    super.actualStartTime,
    super.endTime,
    required super.maxDuration,
    required super.maxParticipants,
    required super.currentParticipants,
    required super.status,
    required super.roomId,
    required super.enrolledStudentIds,
    required super.createdAt,
  });

  factory LiveConferenceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return LiveConferenceModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      instructorId: data['instructorId'] as String,
      instructorName: data['instructorName'] as String,
      price: (data['price'] as num).toDouble(),
      scheduledStartTime: (data['scheduledStartTime'] as Timestamp).toDate(),
      actualStartTime: data['actualStartTime'] != null
          ? (data['actualStartTime'] as Timestamp).toDate()
          : null,
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      maxDuration: data['maxDuration'] as int,
      maxParticipants: data['maxParticipants'] as int,
      currentParticipants: data['currentParticipants'] as int,
      status: data['status'] as String,
      roomId: data['roomId'] as String,
      enrolledStudentIds: List<String>.from(data['enrolledStudentIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'price': price,
      'scheduledStartTime': Timestamp.fromDate(scheduledStartTime),
      'actualStartTime': actualStartTime != null
          ? Timestamp.fromDate(actualStartTime!)
          : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'maxDuration': maxDuration,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'status': status,
      'roomId': roomId,
      'enrolledStudentIds': enrolledStudentIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
