import 'package:learning/core/error/failures.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/chat/domain/entities/chat_room.dart';
import 'package:learning/features/chat/domain/repositories/chat_repository.dart';

class GetChatRooms implements UseCase<List<ChatRoom>, GetChatRoomsParams> {
  final ChatRepository chatRepository;

  GetChatRooms(this.chatRepository);

  @override
  Future<Either<Failure, List<ChatRoom>>> call(
    GetChatRoomsParams params,
  ) async {
    return await chatRepository.getChatRooms(params.companyId);
  }
}

class GetChatRoomsParams {
  final String companyId;

  GetChatRoomsParams({required this.companyId});
}
