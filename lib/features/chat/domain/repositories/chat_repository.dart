import 'package:learning/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/chat/domain/entities/chat_room.dart';
import 'package:learning/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatRoom>>> getChatRooms(String companyId);
  Future<Either<Failure, List<Message>>> getMessages(String roomId);
  Future<Either<Failure, Message>> sendMessage({
    required String roomId,
    required String content,
  });

  /// Create or get existing 1-on-1 chat room
  Future<Either<Failure, ChatRoom>> createChatRoom(String targetUserId);

  /// Create a new group chat room
  Future<Either<Failure, ChatRoom>> createGroupChat({
    required String name,
    required List<String> memberIds,
  });

  /// Subscribe to real-time messages in a chat room
  Stream<List<Message>> subscribeToMessages(String roomId);

  /// Subscribe to ANY new message (for updating chat list last message/time)
  Stream<Message> subscribeToAllMessages();
}
