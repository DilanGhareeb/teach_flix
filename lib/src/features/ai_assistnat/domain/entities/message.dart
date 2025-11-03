import 'package:equatable/equatable.dart';

enum MessageType { text, image, file, audio, video }

enum MessageStatus { sending, sent, delivered, read, failed }

class Message extends Equatable {
  final String id;
  final String text;
  final String authorId;
  final DateTime createdAt;
  final MessageType type;
  final MessageStatus status;
  final String? mediaUrl;
  final String? mediaName;
  final int? mediaSize;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.text,
    required this.authorId,
    required this.createdAt,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.mediaUrl,
    this.mediaName,
    this.mediaSize,
    this.metadata,
  });

  Message copyWith({
    String? id,
    String? text,
    String? authorId,
    DateTime? createdAt,
    MessageType? type,
    MessageStatus? status,
    String? mediaUrl,
    String? mediaName,
    int? mediaSize,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      status: status ?? this.status,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaName: mediaName ?? this.mediaName,
      mediaSize: mediaSize ?? this.mediaSize,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    authorId,
    createdAt,
    type,
    status,
    mediaUrl,
    mediaName,
    mediaSize,
    metadata,
  ];
}
