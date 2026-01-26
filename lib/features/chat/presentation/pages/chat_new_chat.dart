import 'package:flutter/material.dart';

class ChatNewChatPage extends StatelessWidget {
  const ChatNewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Chat')),
      body: const Center(child: Text('New Chat Page Content')),
    );
  }
}
