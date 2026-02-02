import 'package:flutter/material.dart';
import 'package:learning/core/di/injection_container.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/auth/domain/usecases/get_current_user.dart';
import 'package:learning/features/company/domain/usecases/get_company_members.dart';
import 'package:learning/features/chat/presentation/widgets/search_box.dart';
// import 'package:image_picker/image_picker.dart'; // Future use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:learning/features/chat/presentation/pages/chat_room_page.dart';

class ChatNewGroupChatPage extends StatefulWidget {
  const ChatNewGroupChatPage({super.key});

  @override
  State<ChatNewGroupChatPage> createState() => _ChatNewGroupChatPageState();
}

class _ChatNewGroupChatPageState extends State<ChatNewGroupChatPage> {
  List<AuthUser> _members = [];
  final Set<String> _selectedMemberIds = {};
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    final userResult = await sl<GetCurrentUser>()(const NoParams());
    userResult.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to get current user info";
        });
      },
      (user) async {
        if (user != null && user.companyId != null) {
          final membersResult = await sl<GetCompanyMembers>()(
            GetCompanyMembersParams(companyId: user.companyId!),
          );
          membersResult.fold(
            (failure) {
              setState(() {
                _isLoading = false;
                _errorMessage = failure.message;
              });
            },
            (members) {
              setState(() {
                _members = members.where((m) => m.id != user.id).toList();
                _isLoading = false;
              });
            },
          );
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = "You are not in a company";
          });
        }
      },
    );
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedMemberIds.contains(userId)) {
        _selectedMemberIds.remove(userId);
      } else {
        _selectedMemberIds.add(userId);
      }
    });
  }

  void _createGroup(BuildContext context) {
    final groupName = _groupNameController.text.trim();
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a group name")),
      );
      return;
    }
    if (_selectedMemberIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one member")),
      );
      return;
    }

    context.read<ChatBloc>().add(
      CreateGroupChatEvent(
        name: groupName,
        memberIds: _selectedMemberIds.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>(),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatRoomCreated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomPage(
                  roomId: state.chatRoom.id,
                  roomName: state.chatRoom.roomName ?? 'Group Chat',
                ),
              ),
            );
          }
          if (state is ChatFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('New Group'),
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
              ),
              backgroundColor: Colors.white,
              floatingActionButton: _selectedMemberIds.isNotEmpty
                  ? FloatingActionButton(
                      onPressed: () => _createGroup(context),
                      child: const Icon(Icons.check),
                    )
                  : null,
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
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: const Icon(Icons.camera_alt, size: 34),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _groupNameController,
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
                  const SearchBox(),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade300,
                  ),
                  const TabBar(
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blueAccent,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: [
                      Tab(text: "Recent"),
                      Tab(text: "Contacts"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        const Center(
                          child: Text("Recent contacts will appear here"),
                        ),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _errorMessage != null
                            ? Center(child: Text(_errorMessage!))
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                itemCount: _members.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      height: 1,
                                      indent: 70,
                                      color: Color(0xFFEEEEEE),
                                    ),
                                itemBuilder: (context, index) {
                                  final member = _members[index];
                                  final isSelected = _selectedMemberIds
                                      .contains(member.id);
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: member.avatarUrl != null
                                          ? NetworkImage(member.avatarUrl!)
                                          : NetworkImage(
                                              'https://ui-avatars.com/api/?name=${member.fullName ?? member.email}&background=random',
                                            ),
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                    title: Text(
                                      member.fullName ?? 'No Name',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      member.email,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    trailing: Checkbox(
                                      value: isSelected,
                                      onChanged: (val) =>
                                          _toggleSelection(member.id),
                                      activeColor: Colors.blueAccent,
                                      shape: const CircleBorder(),
                                    ),
                                    onTap: () => _toggleSelection(member.id),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
