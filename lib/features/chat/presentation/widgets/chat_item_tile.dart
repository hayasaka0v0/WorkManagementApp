import 'package:flutter/material.dart';

class ChatItemTile extends StatefulWidget {
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final String imageUrl;

  const ChatItemTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.imageUrl,
  });

  @override
  State<ChatItemTile> createState() => _ChatItemTileState();
}

class _ChatItemTileState extends State<ChatItemTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(widget.imageUrl),
      ),
      title: Text(
        widget.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        widget.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          if (widget.unreadCount > 0) ...[
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                widget.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
