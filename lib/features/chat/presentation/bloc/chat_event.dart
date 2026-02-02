part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class GetChatRoomsEvent extends ChatEvent {
  final String companyId;

  GetChatRoomsEvent(this.companyId);
}

final class GetMessagesEvent extends ChatEvent {
  final String roomId;

  GetMessagesEvent(this.roomId);
}

final class SendMessageEvent extends ChatEvent {
  final String roomId;
  final String content;

  SendMessageEvent({required this.roomId, required this.content});
}

final class CreateChatRoomEvent extends ChatEvent {
  final String targetUserId;

  CreateChatRoomEvent({required this.targetUserId});
}

final class CreateGroupChatEvent extends ChatEvent {
  final String name;
  final List<String> memberIds;

  CreateGroupChatEvent({required this.name, required this.memberIds});
}

/// Subscribe to real-time messages in a chat room
final class SubscribeToMessagesEvent extends ChatEvent {
  final String roomId;

  SubscribeToMessagesEvent(this.roomId);
}

/// Unsubscribe from real-time messages
final class UnsubscribeFromMessagesEvent extends ChatEvent {}

/// Internal event triggered when messages are updated via stream
final class MessagesUpdatedEvent extends ChatEvent {
  final List<Message> messages;

  MessagesUpdatedEvent(this.messages);
}
