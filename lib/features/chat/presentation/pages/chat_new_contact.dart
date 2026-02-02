import 'package:flutter/material.dart';
import 'package:learning/core/di/injection_container.dart';
import 'package:learning/core/usecase/usecase.dart';
import 'package:learning/features/auth/domain/entities/auth_user.dart';
import 'package:learning/features/auth/domain/usecases/get_current_user.dart';
import 'package:learning/features/company/domain/usecases/get_company_members.dart';
import 'package:learning/features/chat/presentation/widgets/search_box.dart';
import 'package:learning/features/chat/presentation/pages/chat_room_page.dart'; // Assuming we might want to chat directly?
// Note: If "Add friend" logic is different, we can keep it. But user asked for "show company users".

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/features/chat/presentation/bloc/chat_bloc.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  List<AuthUser> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMembers();
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
                  roomName: state.chatRoom.roomName ?? 'Chat',
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
                const SearchBox(),
                Divider(height: 1, thickness: 0.5, color: Colors.grey.shade300),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: _members.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            indent: 70,
                            color: Color(0xFFEEEEEE),
                          ),
                          itemBuilder: (context, index) {
                            final member = _members[index];
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
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.message,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () {
                                  context.read<ChatBloc>().add(
                                    CreateChatRoomEvent(
                                      targetUserId: member.id,
                                    ),
                                  );
                                },
                              ),
                              onTap: () {
                                context.read<ChatBloc>().add(
                                  CreateChatRoomEvent(targetUserId: member.id),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
