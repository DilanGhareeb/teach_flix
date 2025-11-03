part of 'ai_chat_bloc.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class AiChatSessionRequested extends AiChatEvent {
  final String userId;

  const AiChatSessionRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AiChatNewSessionRequested extends AiChatEvent {
  final String userId;
  final String title;

  const AiChatNewSessionRequested({required this.userId, required this.title});

  @override
  List<Object?> get props => [userId, title];
}

class AiChatSessionSelected extends AiChatEvent {
  final String sessionId;

  const AiChatSessionSelected(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class AiChatMessageSent extends AiChatEvent {
  final String text;

  const AiChatMessageSent(this.text);

  @override
  List<Object?> get props => [text];
}

class AiChatMediaMessageSent extends AiChatEvent {
  final String text;
  final String filePath;
  final MessageType messageType;

  const AiChatMediaMessageSent({
    required this.text,
    required this.filePath,
    required this.messageType,
  });

  @override
  List<Object?> get props => [text, filePath, messageType];
}

class AiChatSessionDeleted extends AiChatEvent {
  final String sessionId;

  const AiChatSessionDeleted(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class AiChatSessionTitleUpdated extends AiChatEvent {
  final String sessionId;
  final String title;

  const AiChatSessionTitleUpdated({
    required this.sessionId,
    required this.title,
  });

  @override
  List<Object?> get props => [sessionId, title];
}

class AiChatMessagesCleared extends AiChatEvent {
  final String sessionId;

  const AiChatMessagesCleared(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class _AiChatSessionsChanged extends AiChatEvent {
  final List<ChatSession> sessions;

  const _AiChatSessionsChanged(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class _AiChatMessagesChanged extends AiChatEvent {
  final List<Message> messages;

  const _AiChatMessagesChanged(this.messages);

  @override
  List<Object?> get props => [messages];
}

class _AiChatSessionsFailed extends AiChatEvent {
  final Failure failure;

  const _AiChatSessionsFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}

class _AiChatMessagesFailed extends AiChatEvent {
  final Failure failure;

  const _AiChatMessagesFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
