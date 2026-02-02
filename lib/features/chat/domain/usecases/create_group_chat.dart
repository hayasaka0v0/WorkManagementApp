import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/chat/domain/entities/chat_room.dart';
import 'package:learning/features/chat/domain/repositories/chat_repository.dart';

class CreateGroupChat implements UseCase<ChatRoom, CreateGroupChatParams> {
  final ChatRepository repository;

  CreateGroupChat(this.repository);

  @override
  Future<Either<Failure, ChatRoom>> call(CreateGroupChatParams params) async {
    return await repository.createGroupChat(
      name: params.name,
      memberIds: params.memberIds,
    );
  }
}

class CreateGroupChatParams {
  final String name;
  final List<String> memberIds;

  CreateGroupChatParams({required this.name, required this.memberIds});
}
