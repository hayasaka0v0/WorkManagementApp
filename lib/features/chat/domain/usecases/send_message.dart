import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/chat/domain/entities/message.dart';
import 'package:learning/features/chat/domain/repositories/chat_repository.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final ChatRepository chatRepository;

  SendMessage(this.chatRepository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await chatRepository.sendMessage(
      roomId: params.roomId,
      content: params.content,
    );
  }
}

class SendMessageParams {
  final String roomId;
  final String content;

  SendMessageParams({required this.roomId, required this.content});
}
