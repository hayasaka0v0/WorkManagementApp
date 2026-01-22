import 'package:flutter/material.dart';
import 'package:learning/features/chat/presentation/widgets/search_box.dart';

class ChatNewGroupChatPage extends StatefulWidget {
  const ChatNewGroupChatPage({super.key});

  @override
  State<ChatNewGroupChatPage> createState() => _ChatNewGroupChatPageState();
}

class _ChatNewGroupChatPageState extends State<ChatNewGroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('New Group')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ), // Viền màu xám
                    ),
                    child: Icon(Icons.camera_alt, size: 34),
                  ),
                  const SizedBox(width: 15),
                  // Text(
                  //   'Set group name',
                  //   style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  // ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Set group name',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            // Search Box Widget
            const SearchBox(),
            Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),

            // TabBar under the divider
            const TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueAccent,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: [
                Tab(text: "Recent"),
                Tab(text: "Contacts"),
              ],
            ),

            // TabBarView content
            Expanded(
              child: TabBarView(
                children: [
                  // Recent Tab Content
                  Center(child: Text("Recent Chats List Here")),

                  // Contacts Tab Content
                  Center(child: Text("Contacts List Here")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
