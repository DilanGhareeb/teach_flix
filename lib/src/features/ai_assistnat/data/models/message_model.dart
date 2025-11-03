import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.text,
    required super.authorId,
    required super.createdAt,
    super.type,
    super.status,
    super.mediaUrl,
    super.mediaName,
    super.mediaSize,
    super.metadata,
  });

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      text: message.text,
      authorId: message.authorId,
      createdAt: message.createdAt,
      type: message.type,
      status: message.status,
      mediaUrl: message.mediaUrl,
      mediaName: message.mediaName,
      mediaSize: message.mediaSize,
      metadata: message.metadata,
    );
  }

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      text: data['text'] ?? '',
      authorId: data['authorId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      type: _messageTypeFromString(data['type']),
      status: _messageStatusFromString(data['status']),
      mediaUrl: data['mediaUrl'],
      mediaName: data['mediaName'],
      mediaSize: data['mediaSize'],
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'authorId': authorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type.name,
      'status': status.name,
      'mediaUrl': mediaUrl,
      'mediaName': mediaName,
      'mediaSize': mediaSize,
      'metadata': metadata,
    };
  }

  static MessageType _messageTypeFromString(String? type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      default:
        return MessageType.text;
    }
  }

  static MessageStatus _messageStatusFromString(String? status) {
    switch (status) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }
}
