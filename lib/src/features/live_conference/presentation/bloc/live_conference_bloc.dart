// live_conference_bloc.dart
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/create_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/delete_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/end_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/get_all_active_conferences.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/join_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/purchase_conference_access.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/start_conference.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/watch_active_conferences.dart';

part 'live_conference_event.dart';
part 'live_conference_state.dart';

class LiveConferenceBloc
    extends Bloc<LiveConferenceEvent, LiveConferenceState> {
  final GetAllActiveConferences getAllActiveConferences;
  final WatchActiveConferences watchActiveConferences;
  final CreateConference createConference;
  final PurchaseConferenceAccess purchaseConferenceAccess;
  final JoinConference joinConference;
  final EndConference endConference;
  final DeleteConference deleteConference;
  final AuthBloc authBloc;
  final StartConference startConference;

  StreamSubscription<Either<Failure, List<LiveConference>>>? _conferencesSub;

  LiveConferenceBloc({
    required this.getAllActiveConferences,
    required this.watchActiveConferences,
    required this.createConference,
    required this.purchaseConferenceAccess,
    required this.joinConference,
    required this.endConference,
    required this.deleteConference,
    required this.authBloc,
    required this.startConference,
  }) : super(const LiveConferenceState()) {
    on<LoadActiveConferences>(_onLoadActiveConferences);
    on<WatchActiveConferencesRequested>(_onWatchActiveConferences);
    on<CreateConferenceRequested>(_onCreateConference);
    on<PurchaseConferenceAccessRequested>(_onPurchaseAccess);
    on<JoinConferenceRequested>(_onJoinConference);
    on<EndConferenceRequested>(_onEndConference);
    on<DeleteConferenceRequested>(_onDeleteConference);
    on<_ActiveConferencesUpdated>(_onActiveConferencesUpdated);
    on<_ActiveConferencesFailed>(_onActiveConferencesFailed);
    on<StartConferenceRequested>(_onStartConference);
  }

  Future<void> _onStartConference(
    StartConferenceRequested event,
    Emitter<LiveConferenceState> emit,
  ) async {
    emit(
      state.copyWith(status: LiveConferenceStatus.starting, clearFailure: true),
    );

    final result = await startConference(event.conferenceId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: LiveConferenceStatus.error, failure: failure),
      ),
      (_) => emit(state.copyWith(status: LiveConferenceStatus.started)),
    );
  }

  Future<void> _onLoadActiveConferences(
    LoadActiveConferences event,
    Emitter<LiveConferenceState> emit,
  ) async {
    emit(
      state.copyWith(status: LiveConferenceStatus.loading, clearFailure: true),
    );

    final result = await getAllActiveConferences();

    result.fold(
      (failure) => emit(
        state.copyWith(status: LiveConferenceStatus.error, failure: failure),
      ),
      (conferences) => emit(
        state.copyWith(
          status: LiveConferenceStatus.loaded,
          activeConferences: conferences,
        ),
      ),
    );
  }

  Future<void> _onWatchActiveConferences(
    WatchActiveConferencesRequested event,
    Emitter<LiveConferenceState> emit,
  ) async {
    await _conferencesSub?.cancel();

    _conferencesSub = watchActiveConferences().listen(
      (either) => either.fold(
        (failure) => add(_ActiveConferencesFailed(failure)),
        (conferences) => add(_ActiveConferencesUpdated(conferences)),
      ),
    );
  }

  void _onActiveConferencesUpdated(
    _ActiveConferencesUpdated event,
    Emitter<LiveConferenceState> emit,
  ) {
    emit(
      state.copyWith(
        status: LiveConferenceStatus.loaded,
        activeConferences: event.conferences,
      ),
    );
  }

  void _onActiveConferencesFailed(
    _ActiveConferencesFailed event,
    Emitter<LiveConferenceState> emit,
  ) {
    emit(
      state.copyWith(
        status: LiveConferenceStatus.error,
        failure: event.failure,
      ),
    );
  }

  Future<void> _onCreateConference(
    CreateConferenceRequested event,
    Emitter<LiveConferenceState> emit,
  ) async {
    emit(
      state.copyWith(status: LiveConferenceStatus.creating, clearFailure: true),
    );

    final result = await createConference(event.params);

    result.fold(
      (failure) => emit(
        state.copyWith(status: LiveConferenceStatus.error, failure: failure),
      ),
      (conference) {
        final updatedList = List<LiveConference>.from(state.activeConferences)
          ..add(conference);

        emit(
          state.copyWith(
            status: LiveConferenceStatus.created,
            selectedConference: conference,
            activeConferences: updatedList,
          ),
        );
      },
    );
  }

  Future<void> _onPurchaseAccess(
    PurchaseConferenceAccessRequested event,
    Emitter<LiveConferenceState> emit,
  ) async {
    final userId = authBloc.state.user?.id;
    if (userId == null) {
      emit(
        state.copyWith(
          status: LiveConferenceStatus.error,
          failure: const UnknownFailure(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: LiveConferenceStatus.purchasing,
        clearFailure: true,
      ),
    );

    final result = await purchaseConferenceAccess(
      PurchaseConferenceParams(
        userId: userId,
        conferenceId: event.conferenceId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: LiveConferenceStatus.error, failure: failure),
      ),
      (_) => emit(state.copyWith(status: LiveConferenceStatus.purchased)),
    );
  }

  Future<void> _onJoinConference(
    JoinConferenceRequested event,
    Emitter<LiveConferenceState> emit,
  ) async {
    final userId = authBloc.state.user?.id;
    if (userId == null) {
      emit(
        state.copyWith(
          status: LiveConferenceStatus.error,
          failure: const UnknownFailure(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: LiveConferenceStatus.joining, clearFailure: true),
    );

    final result = await joinConference(
      JoinConferenceParams(userId: userId, conferenceId: event.conferenceId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: LiveConferenceStatus.error, failure: failure),
      ),
      (_) => emit(state.copyWith(status: LiveConferenceStatus.joined)),
    );
  }

  Future<void> _onEndConference(
    EndConferenceRequested event,
    Emitter<LiveConferenceState> emit,
  ) async {
    emit(
      state.copyWith(status: LiveConferenceStatus.ending, clearFailure: true),
    );

    final result = await endConference(event.conferenceId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: LiveConferenceStatus.error, failure: failure),
      ),
      (_) => emit(state.copyWith(status: LiveConferenceStatus.ended)),
    );
  }

  Future<void> _onDeleteConference(
    DeleteConferenceRequested event,
    Emitter<LiveConferenceState> emit,
  ) async {
    emit(
      state.copyWith(status: LiveConferenceStatus.deleting, clearFailure: true),
    );

    final result = await deleteConference(event.conferenceId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: LiveConferenceStatus.error, failure: failure),
      ),
      (_) {
        // Remove from active conferences list
        final updatedList = state.activeConferences
            .where((conf) => conf.id != event.conferenceId)
            .toList();

        emit(
          state.copyWith(
            status: LiveConferenceStatus.deleted,
            activeConferences: updatedList,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _conferencesSub?.cancel();
    return super.close();
  }
}
