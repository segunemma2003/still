import 'dart:async';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '/app/models/chat.dart';
import '/app/models/message.dart';
import '/app/networking/websocket_service.dart';
import '/app/networking/chat_api_service.dart';

class ChatService {
  // Singleton pattern implementation
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;

  ChatService._internal();

  // Private properties
  final Map<int, Chat> _chats = {};
  final Map<int, List<Message>> _chatMessages = {};
  final Map<int, bool> _hasLoadInitialMessages = {};
  final StreamController<List<Chat>> _chatListController =
      StreamController<List<Chat>>.broadcast();

  final StreamController<Chat> _chatController =
      StreamController<Chat>.broadcast();

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool _isInitialized = false;
  IO.Socket? _socket;

  // Getters
  Stream<List<Chat>> get chatListStream => _chatListController.stream;
  Stream<Chat> get chatStream => _chatController.stream;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isInitialized => _isInitialized;

  /// Private initialization method called in constructor
  Future<void> initialize() async {
    print("Initializing ChatService...");
    if (_isInitialized) return;

    try {
      // Initialize WebSocket connection
      final apiService = ChatApiService();
      final chatListResponse = await apiService.getChatList();
      for (final chat in chatListResponse!.chats) {
        _chats[chat.id] = chat;
      }
      print("Gotten chat list with ${_chats.length} chats");
      await WebSocketService().initializeConnection();

      // Listen to WebSocket messages
      WebSocketService().messageStream.listen(_handleWebSocketMessage);
      WebSocketService()
          .notificationStream
          .listen(_handleWebSocketNotification);

      _isInitialized = true;
      print('✅ ChatService initialized automatically');
    } catch (e) {
      print('❌ Error initializing ChatService: $e');
    }
  }

  /// Load chat list from API
  Future<List<Chat>> loadChatList() async {
    try {
      final chats = _chats.values.toList();
      print("Loaded ${chats} chats");

      chats.sort((a, b) {
        final aTime =
            a.lastMessage?.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime =
            b.lastMessage?.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      // print("Loaded ${chats.length} chats");
      return chats;
    } catch (e) {
      return [];
    }
  }

  /// Get chat details by ID
  Future<Chat?> getChatDetails(int chatId) async {
    try {
      // Check cache first
      if (_chats.containsKey(chatId)) {
        return _chats[chatId];
      }

      // Fetch from API
      final apiService = ChatApiService();
      final chat = await apiService.getChatDetails(chatId: chatId);

      if (chat != null) {
        _chats[chatId] = chat;
        return chat;
      }

      return null;
    } catch (e) {
      print('❌ Error getting chat details: $e');
      return null;
    }
  }

  /// Get messages for a specific chat
  Future<List<Message>> getChatMessages(int chatId) async {
    // Check if initial messages have been loaded for this chat
    if (_hasLoadInitialMessages[chatId] != true) {
      // Fetch initial messages from API
      final apiService = ChatApiService();
      final messagesResponse =
          await apiService.getChatMessages(chatId: chatId, limit: 50);

      if (messagesResponse?.messages.isNotEmpty == true) {
        // Insert fetched messages at the start of the list

        if (_chatMessages.containsKey(chatId)) {
          _chatMessages[chatId]!.insertAll(0, messagesResponse!.messages);
        } else {
          _chatMessages[chatId] =
              List<Message>.from(messagesResponse!.messages);
        }
      } else if (!_chatMessages.containsKey(chatId)) {
        _chatMessages[chatId] = [];
      }
      _hasLoadInitialMessages[chatId] = true;
    }
    return _chatMessages[chatId] ?? [];
  }

  /// Load previous messages for a chat given the last message ID
  Future<List<Message>> loadPreviousMessages(
      int chatId, int lastMessageId) async {
    try {
      final apiService = ChatApiService();
      final messagesResponse = await apiService.getChatMessages(
          chatId: chatId, limit: 20, messageId: lastMessageId);

      if (messagesResponse?.messages.isNotEmpty == true) {
        // Insert fetched messages at the start of the existing list
        if (_chatMessages.containsKey(chatId)) {
          _chatMessages[chatId]!.insertAll(0, messagesResponse!.messages);
        } else {
          _chatMessages[chatId] =
              List<Message>.from(messagesResponse!.messages);
        }

        return messagesResponse!.messages;
      }

      return [];
    } catch (e) {
      print('❌ Error loading previous messages: $e');
      return [];
    }
  }

  /// Add message to chat
  void addMessage(int chatId, Message message) {
    if (!_chatMessages.containsKey(chatId)) {
      _chatMessages[chatId] = [];
    }
    ;
    _chatMessages[chatId]!.add(message);
    // Update last message in chat
    if (_chats.containsKey(chatId)) {
      _chats[chatId]!.lastMessage = message;
      _chats[chatId]!.lastMessageTime = message.createdAt;
      _chats[chatId]!.unreadCount += 1; // Increment unread count

      loadChatList().then((sortedChats) {
        _chatListController.add(sortedChats);
      });
    }
  }

  /// Send message through API
  Future<void> sendMessage(String chatId, String message) async {
    try {
      final apiService = ChatApiService();

      // Create message data for sending
      final messageData = {
        'chat_id': chatId,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Send through API
      await apiService.sendMessage(chatId: int.parse(chatId), message: message);

      // Also emit through WebSocket for real-time delivery
      _socket?.emit('sendMessage', messageData);

      print('✅ Message sent successfully to chat $chatId');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(List<int> messageIds) async {
    try {
      await WebSocketService().sendReadReceipt(messageIds);

      // Update local messages
      for (final chatMessages in _chatMessages.values) {
        for (final message in chatMessages) {
          if (messageIds.contains(message.id)) {
            message.isRead = true;
          }
        }
      }

      _messageController.add({
        'type': 'messages_read',
        'messageIds': messageIds,
      });
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  /// Handle WebSocket messages
  void _handleWebSocketMessage(Map<String, dynamic> messageData) {
    try {
      final message = Message.fromJson(messageData);

      // Add to local cache
      addMessage(message.chatId, message);

      print('📨 Received message for chat ${message.chatId}');
    } catch (e) {
      print('❌ Error handling WebSocket message: $e');
    }
  }

  /// Handle WebSocket notifications
  void _handleWebSocketNotification(Map<String, dynamic> notificationData) {
    try {
      final action = notificationData['action'];

      switch (action) {
        case 'message:delivered':
          _handleMessageDelivered(notificationData);
          break;
        case 'message:read':
          _handleMessageRead(notificationData);
          break;
        case 'user:connected':
        case 'user:disconnected':
          _handleUserStatusChange(notificationData);
          break;
        case 'typing:start':
        case 'typing:stop':
          _handleTypingStatus(notificationData);
          break;
        case 'chat:new':
          _handleNewChat(notificationData);
          break;

        case "join:call":
          _handleJoinCall(notificationData);
          break;

        default:
          print('🔔 Unhandled notification: $action');
      }
    } catch (e) {
      print('❌ Error handling WebSocket notification: $e');
    }
  }

  void _handleNewChat(Map<String, dynamic> data) async {
    try {
      final int chatId = data['chatId'];
      final apiService = ChatApiService();
      final newChat = await apiService.getChatDetails(chatId: chatId);

      if (newChat != null) {
        _chats[newChat.id] = newChat;
        _chatListController.add(_chats.values.toList());
      }
    } catch (e) {
      print('❌ Error handling new chat: $e');
    }
  }

  /// Handle incoming call notification
  void _handleJoinCall(Map<String, dynamic> data) async {
    try {
      final int callerId = data['callerId'];
      final int chatId = data['chatId'];

      print('📞 Incoming call from user $callerId in chat $chatId');
      final userData = await Auth.data();
      final int currentUserId = userData['id'];
      print('Current user ID: $currentUserId');

      if (callerId == currentUserId) {
        // Ignore if the caller is the current user
        return;
      }
      // Get chat details to show caller info
      final chat = await getChatDetails(chatId);

      if (chat != null) {
        // Navigate to voice call page with joining data
        await routeTo(
          "/voice-call",
          data: {
            'isGroup': false,
            'partner': {
              'username': chat.partner?.username ?? 'Unknown',
              'avatar': chat.partner?.avatar ?? 'default_avatar.png',
            },
            'chatId': chatId,
            'callerId': callerId,
            'initiateCall': false, // This indicates joining, not initiating
            'isJoining': true, // Flag to indicate this is an incoming call
          },
        );
      }
    } catch (e) {
      print('❌ Error handling join call: $e');
    }
  }

  /// Handle message delivered notification
  void _handleMessageDelivered(Map<String, dynamic> data) {
    try {
      final List<int> ids = List<int>.from(data['ids']);

      // Update local messages
      for (final chatMessages in _chatMessages.values) {
        for (final message in chatMessages) {
          if (ids.contains(message.id)) {
            message.isDelivered = true;
          }
        }
      }

      _messageController.add({
        'type': 'messages_delivered',
        'messageIds': ids,
      });
    } catch (e) {
      print('❌ Error handling message delivered: $e');
    }
  }

  /// Handle message read notification
  void _handleMessageRead(Map<String, dynamic> data) {
    try {
      final List<int> ids = List<int>.from(data['ids']);

      // Update local messages
      for (final chatMessages in _chatMessages.values) {
        for (final message in chatMessages) {
          if (ids.contains(message.id)) {
            message.isRead = true;

            final Chat? chat = _chats[message.chatId];
            if (chat != null) {
              if (chat.lastMessage?.id == message.id) {
                chat.lastMessage!.isRead = true;
              }

              _chatController.add(chat);
              _chatListController.add(_chats.values.toList());
            }
          }
        }
      }

      _messageController.add({
        'type': 'messages_read',
        'messageIds': ids,
      });
    } catch (e) {
      print('❌ Error handling message read: $e');
    }
  }

  /// Handle user status change
  void _handleUserStatusChange(Map<String, dynamic> data) async {
    final userData = await Auth.data();
    final int currentUserId = userData['id'];

    final int userId = data['userId'];
    final String action = data['action'];

    if (userId != currentUserId) {
      for (final chat in _chats.values) {
        if (chat.partner?.id == userId) {
          chat.partner?.status =
              action == 'user:connected' ? "online" : "offline";
          _chatListController.add(_chats.values.toList());
          break;
        }
      }
    }
  }

  void _handleTypingStatus(Map<String, dynamic> data) async {
    final userData = await Auth.data();
    final int currentUserId = userData['id'];
    final int userId = data['userId'];
    if (userId == currentUserId) return;

    final int chatId = data['chatId'];
    final bool isTyping = data['action'] == 'typing:start';
    final chat = _chats[chatId];

    if (chat == null) return;

    if (isTyping) {
      chat.typingUsers.add(userId);
    } else {
      chat.typingUsers.remove(userId);
    }

    _chatController.add(chat);
    _chatListController.add(_chats.values.toList());
  }

  /// Clear chat cache
  void clearCache() {
    _chats.clear();
    _chatMessages.clear();
  }

  /// Dispose resources
  void dispose() {
    _chatListController.close();
    _messageController.close();
    clearCache();
    _isInitialized = false;
  }
}
