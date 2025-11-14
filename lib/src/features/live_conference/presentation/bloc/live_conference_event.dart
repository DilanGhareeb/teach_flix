part of 'live_conference_bloc.dart';

abstract class LiveConferenceEvent extends Equatable {
  const LiveConferenceEvent();

  @override
  List<Object?> get props => [];
}

class LoadActiveConferences extends LiveConferenceEvent {}

class WatchActiveConferencesRequested extends LiveConferenceEvent {}

class CreateConferenceRequested extends LiveConferenceEvent {
  final CreateConferenceParams params;

  const CreateConferenceRequested(this.params);

  @override
  List<Object?> get props => [params];
}

class PurchaseConferenceAccessRequested extends LiveConferenceEvent {
  final String conferenceId;

  const PurchaseConferenceAccessRequested(this.conferenceId);

  @override
  List<Object?> get props => [conferenceId];
}

class JoinConferenceRequested extends LiveConferenceEvent {
  final String conferenceId;

  const JoinConferenceRequested(this.conferenceId);

  @override
  List<Object?> get props => [conferenceId];
}

class EndConferenceRequested extends LiveConferenceEvent {
  final String conferenceId;

  const EndConferenceRequested(this.conferenceId);

  @override
  List<Object?> get props => [conferenceId];
}

class _ActiveConferencesUpdated extends LiveConferenceEvent {
  final List<LiveConference> conferences;

  const _ActiveConferencesUpdated(this.conferences);

  @override
  List<Object?> get props => [conferences];
}

class _ActiveConferencesFailed extends LiveConferenceEvent {
  final Failure failure;

  const _ActiveConferencesFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class StartConferenceRequested extends LiveConferenceEvent {
  final String conferenceId;

  const StartConferenceRequested(this.conferenceId);

  @override
  List<Object?> get props => [conferenceId];
}
