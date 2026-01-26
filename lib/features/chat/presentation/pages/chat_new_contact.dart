import 'package:flutter/material.dart';
import 'package:learning/features/chat/presentation/widgets/search_box.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  @override
  Widget build(BuildContext context) {
    // Dummy data for contacts
    final List<Map<String, String>> contacts = [
      {
        'name': 'Alice Johnson',
        'email': 'alice.j@example.com',
        'avatar': 'https://via.placeholder.com/150/FF5733/FFFFFF?text=AJ',
      },
      {
        'name': 'Bob Smith',
        'email': 'bob.smith@work.com',
        'avatar': 'https://via.placeholder.com/150/33FF57/FFFFFF?text=BS',
      },
      {
        'name': 'Charlie Davis',
        'email': 'charlie.d@studio.io',
        'avatar': 'https://via.placeholder.com/150/3357FF/FFFFFF?text=CD',
      },
      {
        'name': 'Diana Prince',
        'email': 'diana.p@amaz.on',
        'avatar': 'https://via.placeholder.com/150/FF33A8/FFFFFF?text=DP',
      },
      {
        'name': 'Ethan Hunt',
        'email': 'ethan.h@imf.org',
        'avatar': 'https://via.placeholder.com/150/33FFF5/FFFFFF?text=EH',
      },
      {
        'name': 'Fiona Gallagher',
        'email': 'fiona.g@chicago.net',
        'avatar': 'https://via.placeholder.com/150/F5FF33/FFFFFF?text=FG',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Contact',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Search Box
          const SearchBox(),
          

          // Divider to separate search from list
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),

          // Contact List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: contacts.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: 70, // Indent line to start after avatar
                color: Color(0xFFEEEEEE),
              ),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(contact['avatar']!),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  title: Text(
                    contact['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    contact['email']!,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      // TODO: Implement add friend logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Friend request sent to ${contact['name']}',
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    // TODO: Open contact details or start chat
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
