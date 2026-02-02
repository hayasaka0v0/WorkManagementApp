import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:learning/features/chat/domain/entities/chat_room.dart';
import 'package:learning/features/chat/domain/entities/message.dart';
import 'package:learning/features/chat/domain/usecases/get_chat_rooms.dart';
import 'package:learning/features/chat/domain/usecases/get_messages.dart';
import 'package:learning/features/chat/domain/usecases/send_message.dart';
import 'package:learning/features/chat/domain/usecases/create_chat_room.dart';
import 'package:learning/features/chat/domain/usecases/create_group_chat.dart';
import 'package:learning/features/chat/domain/repositories/chat_repository.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatRooms _getChatRooms;
  final GetMessages _getMessages;
  final SendMessage _sendMessage;
  final CreateChatRoom _createChatRoom;
  final CreateGroupChat _createGroupChat;
  final ChatRepository _chatRepository;

  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required GetChatRooms getChatRooms,
    required GetMessages getMessages,
    required SendMessage sendMessage,
    required CreateChatRoom createChatRoom,
    required CreateGroupChat createGroupChat,
    required ChatRepository chatRepository,
  }) : _getChatRooms = getChatRooms,
       _getMessages = getMessages,
       _sendMessage = sendMessage,
       _createChatRoom = createChatRoom,
       _createGroupChat = createGroupChat,
       _chatRepository = chatRepository,
       super(ChatInitial()) {
    on<GetChatRoomsEvent>(_onGetChatRooms);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<CreateChatRoomEvent>(_onCreateChatRoom);
    on<CreateGroupChatEvent>(_onCreateGroupChat);
    on<SubscribeToMessagesEvent>(_onSubscribeToMessages);
    on<UnsubscribeFromMessagesEvent>(_onUnsubscribeFromMessages);
    on<MessagesUpdatedEvent>(_onMessagesUpdated);
  }

  void _onGetChatRooms(GetChatRoomsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await _getChatRooms(
      GetChatRoomsParams(companyId: event.companyId),
    );
    result.fold(
      (failure) => emit(ChatFailure(failure.message)),
      (chatRooms) => emit(ChatRoomsLoaded(chatRooms)),
    );
  }

  void _onGetMessages(GetMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await _getMessages(GetMessagesParams(roomId: event.roomId));
    result.fold(
      (failure) => emit(ChatFailure(failure.message)),
      (messages) => emit(ChatMessagesLoaded(messages)),
    );
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final result = await _sendMessage(
      SendMessageParams(roomId: event.roomId, content: event.content),
    );
    result.fold(
      (failure) => emit(ChatFailure(failure.message)),
      (message) => emit(ChatMessageSent(message)),
    );
  }

  void _onCreateChatRoom(
    CreateChatRoomEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _createChatRoom(
      CreateChatRoomParams(targetUserId: event.targetUserId),
    );
    result.fold(
      (failure) => emit(ChatFailure(failure.message)),
      (chatRoom) => emit(ChatRoomCreated(chatRoom)),
    );
  }

  void _onCreateGroupChat(
    CreateGroupChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await _createGroupChat(
      CreateGroupChatParams(name: event.name, memberIds: event.memberIds),
    );
    result.fold(
      (failure) => emit(ChatFailure(failure.message)),
      (chatRoom) => emit(ChatRoomCreated(chatRoom)),
    );
  }

  void _onSubscribeToMessages(
    SubscribeToMessagesEvent event,
    Emitter<ChatState> emit,
  ) {
    // Cancel any existing subscription first
    _messagesSubscription?.cancel();

    // Subscribe to the messages stream
    _messagesSubscription = _chatRepository
        .subscribeToMessages(event.roomId)
        .listen((messages) {
          add(MessagesUpdatedEvent(messages));
        });
  }

  void _onUnsubscribeFromMessages(
    UnsubscribeFromMessagesEvent event,
    Emitter<ChatState> emit,
  ) {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }

  void _onMessagesUpdated(MessagesUpdatedEvent event, Emitter<ChatState> emit) {
    emit(ChatMessagesLoaded(event.messages));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
