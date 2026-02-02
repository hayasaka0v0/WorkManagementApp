import 'package:learning/features/chat/domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  ChatRoomModel({
    required super.id,
    required super.companyId,
    super.roomName,
    required super.isGroup,
    super.lastMessage,
    super.lastMessageTime,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    String? lastMsg;
    DateTime? lastTime;

    // Handle Supabase relation
    // Assuming query: select(*, messages(content, created_at))
    // messages will be a list
    if (json['messages'] != null && (json['messages'] as List).isNotEmpty) {
      final lastMessageData =
          (json['messages'] as List).first; // Assuming ordered desc
      lastMsg = lastMessageData['content'];
      if (lastMessageData['created_at'] != null) {
        lastTime = DateTime.parse(lastMessageData['created_at']).toLocal();
      }
    }

    return ChatRoomModel(
      id: json['id'],
      companyId: json['company_id'],
      roomName: json['room_name'],
      isGroup: json['is_group'] ?? false,
      lastMessage: lastMsg,
      lastMessageTime: lastTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'room_name': roomName,
      'is_group': isGroup,
    };
  }
}
