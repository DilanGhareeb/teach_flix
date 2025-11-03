import 'package:equatable/equatable.dart';

class ChatSession extends Equatable {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessageText;
  final int messageCount;

  const ChatSession({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageText,
    this.messageCount = 0,
  });

  ChatSession copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastMessageText,
    int? messageCount,
  }) {
    return ChatSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    createdAt,
    updatedAt,
    lastMessageText,
    messageCount,
  ];
}
