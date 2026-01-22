import 'package:flutter/material.dart';
import 'package:learning/features/chat/presentation/widgets/chat_item_tile.dart';
import 'package:learning/features/chat/presentation/pages/chat_new_chat.dart';
import 'package:learning/features/chat/presentation/pages/chat_new_group_chat.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final List<Map<String, dynamic>> dummyChats = [
      {
        'name': 'Development Team',
        'message': 'We need to discuss the upcoming feature release.',
        'time': '10:30 AM',
        'unreadCount': 2,
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': 'Marketing Group',
        'message': 'The new campaign is live!',
        'time': '09:15 AM',
        'unreadCount': 5,
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': 'Project Manager',
        'message': 'Can you send me the report?',
        'time': 'Yesterday',
        'unreadCount': 0,
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': 'Design Team',
        'message': 'Check out the new prototypes on Figma.',
        'time': 'Yesterday',
        'unreadCount': 1,
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': 'Client Meeting',
        'message': 'Meeting rescheduled to 3 PM.',
        'time': 'Mon',
        'unreadCount': 0,
        'imageUrl': 'https://via.placeholder.com/150',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        scrolledUnderElevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: dummyChats.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          final chat = dummyChats[index];
          return ChatItemTile(
            name: chat['name'],
            message: chat['message'],
            time: chat['time'],
            unreadCount: chat['unreadCount'],
            imageUrl: chat['imageUrl'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'chat_fab',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.person_add_outlined,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        'New Chat',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatNewChatPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.group_add_outlined,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        'New Group',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatNewGroupChatPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
