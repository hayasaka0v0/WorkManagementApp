import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/chat/domain/entities/message.dart';
import 'package:learning/features/chat/domain/repositories/chat_repository.dart';

class GetMessages implements UseCase<List<Message>, GetMessagesParams> {
  final ChatRepository chatRepository;

  GetMessages(this.chatRepository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesParams params) async {
    return await chatRepository.getMessages(params.roomId);
  }
}

class GetMessagesParams {
  final String roomId;

  GetMessagesParams({required this.roomId});
}
