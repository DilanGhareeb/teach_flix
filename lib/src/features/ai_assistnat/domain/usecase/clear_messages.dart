import 'package:dartz/dartz.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class ClearMessages {
  final AiChatRepository repository;

  ClearMessages(this.repository);

  Future<Either<Failure, void>> call({required String params}) {
    return repository.clearMessages(params);
  }
}
