import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/repositories/live_conference_repository.dart';

class CreateConference {
  final LiveConferenceRepository repository;

  CreateConference(this.repository);

  Future<Either<Failure, LiveConference>> call(CreateConferenceParams params) {
    return repository.createConference(
      title: params.title,
      description: params.description,
      instructorId: params.instructorId,
      instructorName: params.instructorName,
      price: params.price,
      scheduledStartTime: params.scheduledStartTime,
      maxDuration: params.maxDuration,
      maxParticipants: params.maxParticipants,
    );
  }
}

class CreateConferenceParams extends Equatable {
  final String title;
  final String description;
  final String instructorId;
  final String instructorName;
  final double price;
  final DateTime scheduledStartTime;
  final int maxDuration;
  final int maxParticipants;

  const CreateConferenceParams({
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.price,
    required this.scheduledStartTime,
    required this.maxDuration,
    required this.maxParticipants,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    instructorId,
    instructorName,
    price,
    scheduledStartTime,
    maxDuration,
    maxParticipants,
  ];
}
