class Message {
  final String id;
  final String roomId;
  final String senderId;
  final String? content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    this.content,
    required this.createdAt,
  });
}
