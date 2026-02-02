import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/di/injection_container.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/usecases/get_current_user.dart';
import 'package:learning/features/chat/domain/entities/chat_room.dart';
import 'package:learning/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:learning/features/chat/presentation/widgets/chat_item_tile.dart';
import 'package:learning/features/chat/presentation/pages/chat_new_contact.dart';
import 'package:learning/features/chat/presentation/pages/chat_new_group_chat.dart';
import 'package:learning/features/chat/presentation/pages/chat_room_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>(),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  void _loadChatRooms() async {
    final userResult = await sl<GetCurrentUser>()(const NoParams());
    userResult.fold(
      (failure) {
        // Handle failure (maybe show snackbar)
      },
      (user) {
        if (user != null && user.companyId != null) {
          if (mounted) {
            context.read<ChatBloc>().add(GetChatRoomsEvent(user.companyId!));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blueAccent),
            onPressed: _loadChatRooms,
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        buildWhen: (previous, current) =>
            current is ChatLoading ||
            current is ChatRoomsLoaded ||
            current is ChatFailure,
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChatRoomsLoaded) {
            if (state.chatRooms.isEmpty) {
              return const Center(child: Text('No chats yet'));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: state.chatRooms.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 80),
              itemBuilder: (context, index) {
                final chat = state.chatRooms[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomPage(
                          roomId: chat.id,
                          roomName: chat.roomName ?? 'Chat',
                        ),
                      ),
                    ).then((_) => _loadChatRooms());
                  },
                  child: ChatItemTile(
                    name: chat.roomName ?? 'Unknown',
                    message: chat.lastMessage ?? 'No messages',
                    time: chat.lastMessageTime != null
                        ? _formatTime(chat.lastMessageTime!)
                        : '',
                    unreadCount: 0, // TODO: Implement unread count
                    imageUrl:
                        'https://ui-avatars.com/api/?name=${chat.roomName}&background=random',
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
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
                            builder: (context) => const NewContact(),
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

  String _formatTime(DateTime time) {
    // Simple helper
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    }
    return "${time.day}/${time.month}";
  }
}
