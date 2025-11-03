part of 'ai_chat_bloc.dart';

enum AiChatStatus {
  initial,
  loading,
  sessionsLoaded,
  chatLoaded,
  sending,
  success,
  failure,
}

class AiChatState extends Equatable {
  final AiChatStatus status;
  final List<ChatSession> sessions;
  final List<Message> messages;
  final ChatSession? currentSession;
  final Failure? failure;
  final bool isSending;

  const AiChatState({
    this.status = AiChatStatus.initial,
    this.sessions = const [],
    this.messages = const [],
    this.currentSession,
    this.failure,
    this.isSending = false,
  });

  AiChatState copyWith({
    AiChatStatus? status,
    List<ChatSession>? sessions,
    List<Message>? messages,
    ChatSession? currentSession,
    Failure? failure,
    bool? isSending,
  }) {
    return AiChatState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      messages: messages ?? this.messages,
      currentSession: currentSession ?? this.currentSession,
      failure: failure,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sessions,
    messages,
    currentSession,
    failure,
    isSending,
  ];
}
