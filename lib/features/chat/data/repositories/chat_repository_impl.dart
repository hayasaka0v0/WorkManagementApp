import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:learning/features/chat/domain/entities/chat_room.dart';
import 'package:learning/features/chat/domain/entities/message.dart';
import 'package:learning/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRooms(String companyId) async {
    try {
      final chatRooms = await remoteDataSource.getChatRooms(companyId);
      return Right(chatRooms);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String roomId) async {
    try {
      final messages = await remoteDataSource.getMessages(roomId);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @override
  Future<Either<Failure, Message>> sendMessage({
    required String roomId,
    required String content,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        roomId: roomId,
        content: content,
      );
      return Right(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatRoom>> createChatRoom(String targetUserId) async {
    try {
      final model = await remoteDataSource.createChatRoom(targetUserId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatRoom>> createGroupChat({
    required String name,
    required List<String> memberIds,
  }) async {
    try {
      final model = await remoteDataSource.createGroupChat(
        name: name,
        memberIds: memberIds,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<Message>> subscribeToMessages(String roomId) {
    return remoteDataSource.subscribeToMessages(roomId).map((models) {
      return models.map((e) => e as Message).toList();
    });
  }

  @override
  Stream<Message> subscribeToAllMessages() {
    return remoteDataSource.subscribeToAllMessages().map(
      (model) => model as Message,
    );
  }
}
