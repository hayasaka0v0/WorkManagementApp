part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatRoomsLoaded extends ChatState {
  final List<ChatRoom> chatRooms;

  ChatRoomsLoaded(this.chatRooms);
}

final class ChatMessagesLoaded extends ChatState {
  final List<Message> messages;

  ChatMessagesLoaded(this.messages);
}

final class ChatFailure extends ChatState {
  final String message;

  ChatFailure(this.message);
}

final class ChatMessageSent extends ChatState {
  final Message message;

  ChatMessageSent(this.message);
}

final class ChatRoomCreated extends ChatState {
  final ChatRoom chatRoom;

  ChatRoomCreated(this.chatRoom);
}
