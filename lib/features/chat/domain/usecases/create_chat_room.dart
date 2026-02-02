import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/chat/domain/entities/chat_room.dart';
import 'package:learning/features/chat/domain/repositories/chat_repository.dart';

class CreateChatRoom implements UseCase<ChatRoom, CreateChatRoomParams> {
  final ChatRepository repository;

  CreateChatRoom(this.repository);

  @override
  Future<Either<Failure, ChatRoom>> call(CreateChatRoomParams params) async {
    return await repository.createChatRoom(params.targetUserId);
  }
}

class CreateChatRoomParams {
  final String targetUserId;

  CreateChatRoomParams({required this.targetUserId});
}
