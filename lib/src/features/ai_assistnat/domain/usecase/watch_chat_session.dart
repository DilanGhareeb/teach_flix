import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class WatchChatSessions {
  final AiChatRepository repository;

  WatchChatSessions(this.repository);

  Stream<Either<Failure, List<ChatSession>>> call({required String params}) {
    return repository.watchChatSessions(params);
  }
}
