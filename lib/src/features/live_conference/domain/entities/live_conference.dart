import 'package:equatable/equatable.dart';

class LiveConference extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String instructorName;
  final double price;
  final DateTime scheduledStartTime;
  final DateTime? actualStartTime;
  final DateTime? endTime;
  final int maxDuration; // in minutes
  final int maxParticipants;
  final int currentParticipants;
  final String status; // 'scheduled', 'live', 'ended'
  final String roomId;
  final List<String> enrolledStudentIds;
  final DateTime createdAt;

  const LiveConference({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.price,
    required this.scheduledStartTime,
    this.actualStartTime,
    this.endTime,
    required this.maxDuration,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.status,
    required this.roomId,
    required this.enrolledStudentIds,
    required this.createdAt,
  });

  bool get isLive => status == 'live';
  bool get hasEnded => status == 'ended';
  bool get isScheduled => status == 'scheduled';

  bool get canJoin {
    if (status != 'live' || actualStartTime == null) return false;

    final now = DateTime.now();
    final elapsed = now.difference(actualStartTime!).inMinutes;

    // Students can join within first 10 minutes of start
    return elapsed <= 10;
  }

  bool get isFull => currentParticipants >= maxParticipants;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    instructorId,
    instructorName,
    price,
    scheduledStartTime,
    actualStartTime,
    endTime,
    maxDuration,
    maxParticipants,
    currentParticipants,
    status,
    roomId,
    enrolledStudentIds,
    createdAt,
  ];
}
