import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/data/datasource/ai_chat_remote_data_source.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDataSource remoteDataSource;

  AiChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String sessionId,
    required String userId,
    required String text,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        sessionId: sessionId,
        userId: userId,
        text: text,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessageWithMedia({
    required String sessionId,
    required String userId,
    required String text,
    required String filePath,
    required MessageType messageType,
  }) async {
    try {
      final result = await remoteDataSource.sendMessageWithMedia(
        sessionId: sessionId,
        userId: userId,
        text: text,
        filePath: filePath,
        messageType: messageType,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> watchMessages(String sessionId) {
    try {
      return remoteDataSource
          .watchMessages(sessionId)
          .map((messages) => Right<Failure, List<Message>>(messages));
    } on ServerException catch (e) {
      return Stream.value(Left(ServerFailure()));
    } catch (e) {
      return Stream.value(Left(UnknownFailure()));
    }
  }

  @override
  Future<Either<Failure, ChatSession>> createChatSession({
    required String userId,
    required String title,
  }) async {
    try {
      final result = await remoteDataSource.createChatSession(
        userId: userId,
        title: title,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Stream<Either<Failure, List<ChatSession>>> watchChatSessions(String userId) {
    try {
      return remoteDataSource
          .watchChatSessions(userId)
          .map((sessions) => Right<Failure, List<ChatSession>>(sessions));
    } on ServerException catch (e) {
      return Stream.value(Left(ServerFailure()));
    } catch (e) {
      return Stream.value(Left(UnknownFailure()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChatSession(String sessionId) async {
    try {
      await remoteDataSource.deleteChatSession(sessionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateChatSessionTitle({
    required String sessionId,
    required String title,
  }) async {
    try {
      await remoteDataSource.updateChatSessionTitle(
        sessionId: sessionId,
        title: title,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearMessages(String sessionId) async {
    try {
      await remoteDataSource.clearMessages(sessionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getAiResponse({
    required String sessionId,
    required String userId,
    required String message,
    List<Message>? conversationHistory,
  }) async {
    try {
      final result = await remoteDataSource.getAiResponse(
        sessionId: sessionId,
        userId: userId,
        message: message,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
