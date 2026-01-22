import 'package:flutter/material.dart';

class ChatNewChatPage extends StatefulWidget {
  const ChatNewChatPage({super.key});

  @override
  State<ChatNewChatPage> createState() => _ChatNewChatPageState();
}

class _ChatNewChatPageState extends State<ChatNewChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: const Center(
        child: Text('New Chat Page'),
      ),
    );
  }
}