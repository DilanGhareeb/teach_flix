import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class SendMessageWithMedia {
  final AiChatRepository repository;

  SendMessageWithMedia(this.repository);

  Future<Either<Failure, Message>> call({
    required SendMessageWithMediaParams params,
  }) {
    return repository.sendMessageWithMedia(
      sessionId: params.sessionId,
      userId: params.userId,
      text: params.text,
      filePath: params.filePath,
      messageType: params.messageType,
    );
  }
}

class SendMessageWithMediaParams extends Equatable {
  final String sessionId;
  final String userId;
  final String text;
  final String filePath;
  final MessageType messageType;

  const SendMessageWithMediaParams({
    required this.sessionId,
    required this.userId,
    required this.text,
    required this.filePath,
    required this.messageType,
  });

  @override
  List<Object?> get props => [sessionId, userId, text, filePath, messageType];
}
