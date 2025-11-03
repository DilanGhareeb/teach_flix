import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';

abstract class AiChatRepository {
  Future<Either<Failure, Message>> sendMessage({
    required String sessionId,
    required String userId,
    required String text,
  });

  Future<Either<Failure, Message>> sendMessageWithMedia({
    required String sessionId,
    required String userId,
    required String text,
    required String filePath,
    required MessageType messageType,
  });

  Stream<Either<Failure, List<Message>>> watchMessages(String sessionId);

  Future<Either<Failure, ChatSession>> createChatSession({
    required String userId,
    required String title,
  });

  Stream<Either<Failure, List<ChatSession>>> watchChatSessions(String userId);

  Future<Either<Failure, void>> deleteChatSession(String sessionId);

  Future<Either<Failure, void>> updateChatSessionTitle({
    required String sessionId,
    required String title,
  });

  Future<Either<Failure, void>> clearMessages(String sessionId);

  Future<Either<Failure, String>> getAiResponse({
    required String sessionId,
    required String userId,
    required String message,
    List<Message>? conversationHistory,
  });
}
