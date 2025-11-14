part of 'live_conference_bloc.dart';

enum LiveConferenceStatus {
  initial,
  loading,
  loaded,
  creating,
  created,
  purchasing,
  purchased,
  joining,
  joined,
  ending,
  ended,
  error,
  starting,
  started,
  deleting,
  deleted,
}

class LiveConferenceState extends Equatable {
  final LiveConferenceStatus status;
  final List<LiveConference> activeConferences;
  final LiveConference? selectedConference;
  final Failure? failure;

  const LiveConferenceState({
    this.status = LiveConferenceStatus.initial,
    this.activeConferences = const [],
    this.selectedConference,
    this.failure,
  });

  LiveConferenceState copyWith({
    LiveConferenceStatus? status,
    List<LiveConference>? activeConferences,
    LiveConference? selectedConference,
    bool clearSelectedConference = false,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return LiveConferenceState(
      status: status ?? this.status,
      activeConferences: activeConferences ?? this.activeConferences,
      selectedConference: clearSelectedConference
          ? null
          : (selectedConference ?? this.selectedConference),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    status,
    activeConferences,
    selectedConference,
    failure,
  ];
}
