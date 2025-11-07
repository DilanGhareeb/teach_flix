import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class UpdateChatSessionTitle {
  final AiChatRepository repository;

  UpdateChatSessionTitle(this.repository);

  Future<Either<Failure, void>> call({
    required UpdateChatSessionTitleParams params,
  }) {
    return repository.updateChatSessionTitle(
      sessionId: params.sessionId,
      title: params.title,
    );
  }
}

class UpdateChatSessionTitleParams extends Equatable {
  final String sessionId;
  final String title;

  const UpdateChatSessionTitleParams({
    required this.sessionId,
    required this.title,
  });

  @override
  List<Object?> get props => [sessionId, title];
}
