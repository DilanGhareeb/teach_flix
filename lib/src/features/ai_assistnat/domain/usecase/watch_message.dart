import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class WatchMessages {
  final AiChatRepository repository;

  WatchMessages(this.repository);

  Stream<Either<Failure, List<Message>>> call({required String params}) {
    return repository.watchMessages(params);
  }
}
