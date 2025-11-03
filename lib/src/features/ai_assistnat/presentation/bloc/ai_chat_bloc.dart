import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/create_chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/delete_chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/send_message.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/send_message_with_media.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/watch_chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/usecase/watch_message.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final CreateChatSession createChatSession;
  final WatchChatSessions watchChatSessions;
  final WatchMessages watchMessages;
  final SendMessage sendMessage;
  final SendMessageWithMedia sendMessageWithMedia;
  final DeleteChatSession deleteChatSession;

  StreamSubscription<Either<Failure, List<ChatSession>>>? _sessionsSub;
  StreamSubscription<Either<Failure, List<Message>>>? _messagesSub;

  AiChatBloc({
    required this.createChatSession,
    required this.watchChatSessions,
    required this.watchMessages,
    required this.sendMessage,
    required this.sendMessageWithMedia,
    required this.deleteChatSession,
  }) : super(const AiChatState()) {
    on<AiChatSessionRequested>(_onSessionRequested);
    on<AiChatNewSessionRequested>(_onNewSessionRequested);
    on<AiChatSessionSelected>(_onSessionSelected);
    on<AiChatMessageSent>(_onMessageSent);
    on<AiChatMediaMessageSent>(_onMediaMessageSent);
    on<AiChatSessionDeleted>(_onSessionDeleted);
    on<AiChatMessagesCleared>(_onMessagesCleared);
    on<_AiChatSessionsChanged>(_onSessionsChanged);
    on<_AiChatMessagesChanged>(_onMessagesChanged);
    on<_AiChatSessionsFailed>(_onSessionsFailed);
    on<_AiChatMessagesFailed>(_onMessagesFailed);
  }

  Future<void> _onSessionRequested(
    AiChatSessionRequested event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(status: AiChatStatus.loading, failure: null));

    await _sessionsSub?.cancel();
    _sessionsSub = watchChatSessions(params: event.userId).listen(
      (either) => either.fold(
        (f) => add(_AiChatSessionsFailed(f)),
        (sessions) => add(_AiChatSessionsChanged(sessions)),
      ),
    );
  }

  Future<void> _onNewSessionRequested(
    AiChatNewSessionRequested event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(status: AiChatStatus.loading, failure: null));

    final result = await createChatSession(
      params: CreateChatSessionParams(userId: event.userId, title: event.title),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: AiChatStatus.failure, failure: failure)),
      (session) {
        add(AiChatSessionSelected(session.id));
      },
    );
  }

  Future<void> _onSessionSelected(
    AiChatSessionSelected event,
    Emitter<AiChatState> emit,
  ) async {
    // Find the session, or use first available if not found
    ChatSession? session;
    try {
      session = state.sessions.firstWhere((s) => s.id == event.sessionId);
    } catch (e) {
      // If not found and we have sessions, use the first one
      if (state.sessions.isNotEmpty) {
        session = state.sessions.first;
      } else {
        // No sessions available, emit failure
        emit(
          state.copyWith(
            status: AiChatStatus.failure,
            failure: NotFoundFailure(),
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        currentSession: session,
        messages: [],
        status: AiChatStatus.loading,
        failure: null,
      ),
    );

    await _messagesSub?.cancel();
    _messagesSub = watchMessages(params: event.sessionId).listen(
      (either) => either.fold(
        (f) => add(_AiChatMessagesFailed(f)),
        (messages) => add(_AiChatMessagesChanged(messages)),
      ),
    );
  }

  Future<void> _onMessageSent(
    AiChatMessageSent event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.currentSession == null) return;

    emit(state.copyWith(isSending: true, failure: null));

    final result = await sendMessage(
      params: SendMessageParams(
        sessionId: state.currentSession!.id,
        userId: state.currentSession!.userId,
        text: event.text,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AiChatStatus.failure,
          failure: failure,
          isSending: false,
        ),
      ),
      (_) => emit(state.copyWith(isSending: false)),
    );
  }

  Future<void> _onMediaMessageSent(
    AiChatMediaMessageSent event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.currentSession == null) return;

    emit(state.copyWith(isSending: true, failure: null));

    final result = await sendMessageWithMedia(
      params: SendMessageWithMediaParams(
        sessionId: state.currentSession!.id,
        userId: state.currentSession!.userId,
        text: event.text,
        filePath: event.filePath,
        messageType: event.messageType,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AiChatStatus.failure,
          failure: failure,
          isSending: false,
        ),
      ),
      (_) => emit(state.copyWith(isSending: false)),
    );
  }

  Future<void> _onSessionDeleted(
    AiChatSessionDeleted event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(status: AiChatStatus.loading, failure: null));

    final result = await deleteChatSession(params: event.sessionId);

    result.fold(
      (failure) =>
          emit(state.copyWith(status: AiChatStatus.failure, failure: failure)),
      (_) {
        if (state.currentSession?.id == event.sessionId) {
          emit(
            state.copyWith(
              currentSession: null,
              messages: [],
              status: AiChatStatus.sessionsLoaded,
            ),
          );
        }
      },
    );
  }

  Future<void> _onMessagesCleared(
    AiChatMessagesCleared event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(status: AiChatStatus.loading, failure: null));
    // Implementation would require a use case
    emit(state.copyWith(status: AiChatStatus.chatLoaded));
  }

  void _onSessionsChanged(
    _AiChatSessionsChanged event,
    Emitter<AiChatState> emit,
  ) {
    emit(
      state.copyWith(
        status: AiChatStatus.sessionsLoaded,
        sessions: event.sessions,
        failure: null,
      ),
    );
  }

  void _onMessagesChanged(
    _AiChatMessagesChanged event,
    Emitter<AiChatState> emit,
  ) {
    emit(
      state.copyWith(
        status: AiChatStatus.chatLoaded,
        messages: event.messages,
        failure: null,
      ),
    );
  }

  void _onSessionsFailed(
    _AiChatSessionsFailed event,
    Emitter<AiChatState> emit,
  ) {
    emit(state.copyWith(status: AiChatStatus.failure, failure: event.failure));
  }

  void _onMessagesFailed(
    _AiChatMessagesFailed event,
    Emitter<AiChatState> emit,
  ) {
    emit(state.copyWith(status: AiChatStatus.failure, failure: event.failure));
  }

  @override
  Future<void> close() {
    _sessionsSub?.cancel();
    _messagesSub?.cancel();
    return super.close();
  }
}
