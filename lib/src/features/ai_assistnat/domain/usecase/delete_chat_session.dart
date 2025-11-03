import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class DeleteChatSession {
  final AiChatRepository repository;

  DeleteChatSession(this.repository);

  Future<Either<Failure, void>> call({required String params}) {
    return repository.deleteChatSession(params);
  }
}
