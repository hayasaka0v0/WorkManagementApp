class ChatRoom {
  final String id;
  final String companyId;
  final String? roomName;
  final bool isGroup;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoom({
    required this.id,
    required this.companyId,
    this.roomName,
    required this.isGroup,
    this.lastMessage,
    this.lastMessageTime,
  });
}
