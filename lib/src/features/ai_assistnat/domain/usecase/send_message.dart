import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class SendMessage {
  final AiChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call({required SendMessageParams params}) {
    return repository.sendMessage(
      sessionId: params.sessionId,
      userId: params.userId,
      text: params.text,
    );
  }
}

class SendMessageParams extends Equatable {
  final String sessionId;
  final String userId;
  final String text;

  const SendMessageParams({
    required this.sessionId,
    required this.userId,
    required this.text,
  });

  @override
  List<Object?> get props => [sessionId, userId, text];
}
