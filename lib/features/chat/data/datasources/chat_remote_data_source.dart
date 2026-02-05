import 'dart:async';
import 'package:learning/core/error/failures.dart';
import 'package:learning/features/chat/data/models/chat_room_model.dart';
import 'package:learning/features/chat/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> getChatRooms(String companyId);
  Future<List<MessageModel>> getMessages(String roomId);
  Future<MessageModel> sendMessage({
    required String roomId,
    required String content,
  });

  Future<ChatRoomModel> createChatRoom(String targetUserId);

  Future<ChatRoomModel> createGroupChat({
    required String name,
    required List<String> memberIds,
  });

  /// Subscribe to real-time messages in a chat room
  Stream<List<MessageModel>> subscribeToMessages(String roomId);

  /// Subscribe to ANY new message
  Stream<MessageModel> subscribeToAllMessages();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  ChatRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ChatRoomModel>> getChatRooms(String companyId) async {
    try {
      final response = await supabaseClient
          .from('chat_rooms')
          .select('*, messages(content, created_at)')
          .eq('company_id', companyId)
          .order('created_at', ascending: false, referencedTable: 'messages')
          .limit(
            1,
            referencedTable: 'messages',
          ); // Limit messages to 1 per room

      // Note: Supabase implementation details for fetching "last message per group" can be tricky.
      // The above query fetches chat_rooms and their messages (limit 1, ordered desc).
      // We rely on Supabase to execute this correctly.
      // If .limit(..., referencedTable) is not supported in this SDK version, we might get more messages or error.
      // Let's assume standard PostgREST syntax support via supabase-flutter -> select query string.

      return (response as List).map((e) => ChatRoomModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String roomId) async {
    try {
      final response = await supabaseClient
          .from('messages')
          .select()
          .eq('room_id', roomId)
          .order('created_at', ascending: false);

      final messages =
          (response as List).map((e) => MessageModel.fromJson(e)).toList()
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      return messages;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String roomId,
    required String content,
  }) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw ServerFailure('User not authenticated');
      }

      final response = await supabaseClient
          .from('messages')
          .insert({'room_id': roomId, 'sender_id': user.id, 'content': content})
          .select()
          .single();

      return MessageModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ChatRoomModel> createChatRoom(String targetUserId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw ServerFailure('User not authenticated');
      }
      final currentUserId = user.id;

      // 1. Check if a private chat room already exists between these two users
      // This is a complex query. We need to find a room where BOTH users are participants AND type is 'private'.
      // Supabase RPC is best for this, but let's try client-side logic if RPC not available.
      // Or: Query chat_participants for current user, then filter.

      // Option A: Use a stored procedure (RPC) - Recommended for performance.
      // Option B: Two steps query.
      // Let's try Option B (Client-side filtering usually bad but acceptable for MVP).
      // Better Query:
      // select room_id from chat_participants where user_id in (A, B) group by room_id having count(distinct user_id) = 2
      // AND room is private.

      // Simplified approach for MVP without RPC:
      // 1. Fetch all private rooms for current user.
      // 2. For each room, check if targetUserId is also a participant.
      // This is slow if user has many chats.

      // Let's assume we can query chat_rooms directly if we had a unique constraint or special field.
      // But we don't.

      // Let's use rpc if possible. If not, fallback.
      // Function: get_private_chat_room(user_id_1, user_id_2)

      // Since I can't create RPC now easily without SQL access tool, I will use a slightly inefficient query or just create a new one and let backend handle dupe? No, we shouldn't create dupes.

      // Alternative:
      // Get all private specific rooms involving currentUser.
      final myRoomsResponse = await supabaseClient
          .from('chat_participants')
          .select('room_id, chat_rooms!inner(is_group)')
          .eq('user_id', currentUserId)
          .eq('chat_rooms.is_group', false); // Private chat = is_group false

      final myRoomIds = (myRoomsResponse as List)
          .map((e) => e['room_id'])
          .toList();

      if (myRoomIds.isNotEmpty) {
        final targetInRooms = await supabaseClient
            .from('chat_participants')
            .select('room_id')
            .inFilter('room_id', myRoomIds)
            .eq('user_id', targetUserId);

        if ((targetInRooms as List).isNotEmpty) {
          final existingRoomId = targetInRooms[0]['room_id'];
          // Fetch full room details
          final roomResponse = await supabaseClient
              .from('chat_rooms')
              .select(
                '*, messages(content, created_at)',
              ) // Fetch last message too if possible
              .eq('id', existingRoomId)
              .single();
          // Manually fetch messages if needed, or rely on model.
          // Model expects messages for lastMessage.
          // If messages is empty/null, handle it.
          return ChatRoomModel.fromJson(roomResponse);
        }
      }

      // 2. If not found, create new room
      final userCompanyId = await _getUserCompanyId(currentUserId);

      // Start transaction-like flow (no real transaction in client lib without RPC)
      final roomResponse = await supabaseClient
          .from('chat_rooms')
          .insert({
            'room_name': null, // For private chat, display other user's name
            'is_group': false,
            'company_id': userCompanyId,
          })
          .select()
          .single();

      final newRoomId = roomResponse['id'];

      // Add participants
      await supabaseClient.from('chat_participants').insert([
        {'room_id': newRoomId, 'user_id': currentUserId},
        {'room_id': newRoomId, 'user_id': targetUserId},
      ]);

      return ChatRoomModel.fromJson(roomResponse);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ChatRoomModel> createGroupChat({
    required String name,
    required List<String> memberIds,
  }) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw ServerFailure('User not authenticated');
      }
      final currentUserId = user.id;
      final userCompanyId = await _getUserCompanyId(currentUserId);

      // Create room
      final roomResponse = await supabaseClient
          .from('chat_rooms')
          .insert({
            'room_name': name,
            'is_group': true,
            'company_id': userCompanyId,
          })
          .select()
          .single();

      final newRoomId = roomResponse['id'];

      // Prepare participants list (current user + members)
      // Use Set to avoid duplicates
      final allMembers = {currentUserId, ...memberIds};
      final participantsData = allMembers
          .map((uid) => {'room_id': newRoomId, 'user_id': uid})
          .toList();

      await supabaseClient.from('chat_participants').insert(participantsData);

      return ChatRoomModel.fromJson(roomResponse);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<String?> _getUserCompanyId(String userId) async {
    final response = await supabaseClient
        .from('users')
        .select('company_id')
        .eq('id', userId)
        .single();
    return response['company_id'];
  }

  @override
  Stream<List<MessageModel>> subscribeToMessages(String roomId) {
    return supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
        .map((data) {
          final messages = data.map((e) => MessageModel.fromJson(e)).toList();
          messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          return messages;
        });
  }

  @override
  Stream<MessageModel> subscribeToAllMessages() {
    final controller = StreamController<MessageModel>();

    supabaseClient
        .channel('public:messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            if (payload.newRecord != null) {
              controller.add(MessageModel.fromJson(payload.newRecord!));
            }
          },
        )
        .subscribe();

    return controller.stream;
  }
}
