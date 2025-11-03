import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/chat_session.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/repository/chat_ai_repository.dart';

class CreateChatSession {
  final AiChatRepository repository;

  CreateChatSession(this.repository);

  Future<Either<Failure, ChatSession>> call({
    required CreateChatSessionParams params,
  }) {
    return repository.createChatSession(
      userId: params.userId,
      title: params.title,
    );
  }
}

class CreateChatSessionParams extends Equatable {
  final String userId;
  final String title;

  const CreateChatSessionParams({required this.userId, required this.title});

  @override
  List<Object?> get props => [userId, title];
}
