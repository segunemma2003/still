import 'dart:async';
import 'dart:convert';
// import 'dart:io';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();
  IO.Socket? _socket;

  // WebSocket? _webSocket;
  String? _currentChatId;
  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  // Stream controllers for different types of messages
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _chatListController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  // Getters
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;
  Stream<Map<String, dynamic>> get chatListStream => _chatListController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  bool get isConnected => _isConnected;
  String? get currentChatId => _currentChatId;

  /// Initialize Socket.IO connection for general notifications and chat list updates
  Future<void> initializeConnection() async {
    if (_socket != null && _socket!.connected) return;

    _isConnecting = true;
    try {
      Map<String, dynamic>? userData = await Auth.data();
      String? accessToken = userData != null ? userData['accessToken'] : null;

      _socket = IO.io(getEnv('API_BASE_URL'), <String, dynamic>{
        'transports': <String>[
          'websocket',
          'polling'
        ], // Add polling as fallback
        'autoConnect': false,
        'auth': {
          'token': accessToken,
        },
        'timeout': 20000, // 20 second timeout
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
        'forceNew': true, // Force new connection
        'upgrade': true, // Allow transport upgrade
        'rememberUpgrade': true, // Remember transport preference
      });
      _socket!.connect();

      _socket!.on('connect', (_) async {
        print('Socket.IO connected');
        _isConnected = true;
        _isConnecting = false;
        _reconnectAttempts = 0;
        _connectionStatusController.add(true);
        await _sendAuthMessage();
      });

      _socket!.on('disconnect', (reason) {
        print('Socket.IO disconnected: $reason');
        _isConnected = false;
        _connectionStatusController.add(false);
        _handleDisconnection();
      });

      _socket!.on('connect_error', (error) {
        print('Socket.IO connection error: $error');
        _isConnected = false;
        _connectionStatusController.add(false);
        _handleError(error);
      });

      _socket!.on('reconnect', (attemptNumber) {
        print('Socket.IO reconnected after $attemptNumber attempts');
        _isConnected = true;
        _connectionStatusController.add(true);
        _reconnectAttempts = 0;
      });

      _socket!.on('reconnect_error', (error) {
        print('Socket.IO reconnection error: $error');
        _handleError(error);
      });

      _socket!.on('message',
          (data) => _handleIncomingMessage('message', jsonEncode(data)));
      _socket!.on('message:new',
          (data) => _handleIncomingMessage('message:new', jsonEncode(data)));
      _socket!.on('new_message',
          (data) => _handleIncomingMessage('new_message', jsonEncode(data)));
      _socket!.on('chat_message',
          (data) => _handleIncomingMessage('chat_message', jsonEncode(data)));
      _socket!.on('message:edit',
          (data) => _handleIncomingMessage('message:edit', jsonEncode(data)));
      _socket!.on('message:delete',
          (data) => _handleIncomingMessage('message:delete', jsonEncode(data)));
      _socket!.on('notification',
          (data) => _handleIncomingMessage('notification', jsonEncode(data)));
      _socket!.on(
          'chat_list_update',
          (data) =>
              _handleIncomingMessage('chat_list_update', jsonEncode(data)));
      _socket!.on('typing',
          (data) => _handleIncomingMessage('typing', jsonEncode(data)));
      _socket!.on('read_receipt',
          (data) => _handleIncomingMessage('read_receipt', jsonEncode(data)));

      // Catch-all listener for debugging
      _socket!.onAny((event, data) {
        print('🎯 Received ANY event: $event with data: $data');
        if (event.startsWith('message') || event.contains('message')) {
          _handleIncomingMessage(event, jsonEncode(data));
        }
      });
    } catch (e) {
      _isConnecting = false;
      _handleError(e);
    }
  }

  /// Connect to a specific chat room
  Future<void> connectToChat({required String chatId}) async {
    if (_currentChatId == chatId && _isConnected) {
      print('Already connected to chat $chatId');
      return;
    }

    // Disconnect from current chat if different
    if (_currentChatId != null && _currentChatId != chatId) {
      await _disconnectFromChat();
    }

    try {
      _currentChatId = chatId;
      // Emit a join event to the server for the chat room with acknowledgment
      _socket?.emitWithAck('join_chat', {'chatId': chatId}, ack: (data) {
        print('✅ Server acknowledged join_chat: $data');
      });
      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionStatusController.add(true);
      print('Socket.IO joined chat $chatId');
      await _sendAuthMessage();
    } catch (e) {
      print('Error connecting to chat $chatId: $e');
      _handleError(e);
    }
  }

  /// Send authentication message with Bearer token
  Future<void> _sendAuthMessage() async {
    try {
      Map<String, dynamic>? userData = await Auth.data();
      if (userData != null && userData['accessToken'] != null) {
        final authMessage = {
          'type': 'auth',
          'token': userData['accessToken'],
        };
        _socket?.emit('auth', authMessage);
      }
    } catch (e) {
      print('Error sending auth message: $e');
    }
  }

  /// Handle incoming messages and route them to appropriate streams
  void _handleIncomingMessage(String type, dynamic data) {
    try {
      final messageData = jsonDecode(data);
      print('🔍 Received message of type $type: $messageData');
      print('🔍 Message data keys: ${messageData.keys.toList()}');
      switch (type) {
        case 'message':
        case 'message:new':
        case 'new_message':
        case 'chat_message':
          print('✅ Received new message: $messageData');
          _messageController.add(messageData);
          break;
        case 'message:edit':
          print('Editing message: $messageData');
          _messageController.add(messageData);
          break;
        case 'message:delete':
          print('Deleting message: $messageData');
          _messageController.add({'action': 'delete', ...messageData});
          break;
        case 'notification':
          _notificationController.add(messageData);
          break;
        case 'chat_list_update':
          _chatListController.add(messageData);
          break;
        case 'typing':
          _messageController.add(messageData);
          break;
        case 'read_receipt':
          _messageController.add(messageData);
          break;
        default:
          print('Unknown message type: $type');
      }
    } catch (e) {
      print('Error parsing incoming message: $e');
    }
  }

  /// Send a message to the current chat
  Future<void> sendMessage(String message, int chatId) async {
    print('🚀 === SENDMESSAGE METHOD CALLED ===');
    print('🔍 === MESSAGE SEND DEBUG ===');
    print('🔍 WebSocket connected: $_isConnected');
    print('🔍 Socket exists: ${_socket != null}');
    print('🔍 Current chat ID: $_currentChatId');
    print('🔍 Target chat ID: $chatId');

    if (!_isConnected || _socket == null) {
      print('❌ Socket.IO not connected');
      return;
    }

    try {
      final messageData = {
        'type': 'TEXT',
        'text': message,
        'chatId': chatId,
      };

      print('📤 WebSocket sending message: $messageData');
      print('📤 Event: message:send');
      print('📤 Socket state: ${_socket!.connected}');
      print('📤 Timestamp: ${DateTime.now().toIso8601String()}');

      print('🚀 ===== EMITTING EVENT: message:send =====');
      print('🚀 Event: message:send');
      print('🚀 Data: $messageData');

      // Send with acknowledgment for Socket.IO
      _socket!.emitWithAck('message:send', messageData, ack: (data) {
        print('✅ Server acknowledged message:send: $data');
      });

      print('✅ ===== EVENT SENT: message:send =====');
      print('✅ Message sent via WebSocket: $message');

      // Send message using the correct event name: message:send
      print('✅ Using correct event: message:send');

      // Add listeners for various response events
      _socket!.once('message:sent', (data) {
        print('✅ Server confirmed message sent: $data');
      });

      _socket!.once('message:error', (data) {
        print('❌ Server returned message error: $data');
      });

      _socket!.once('error', (data) {
        print('❌ General WebSocket error: $data');
      });
    } catch (e) {
      print('❌ Error sending message: $e');
      print('❌ Error stack trace: ${e.toString()}');
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(bool isTyping, int chatId) async {
    if (!_isConnected || _socket == null) return;

    try {
      final typingData = {
        'chatId': chatId,
      };

      final event = isTyping ? 'typing:start' : 'typing:stop';
      print('🚀 EMITTING TYPING EVENT: $event');
      print('📤 Typing data: $typingData');
      print('📤 Timestamp: ${DateTime.now().toIso8601String()}');
      _socket!.emit(event, typingData);
      print(
          '✅ TYPING EVENT SENT: $event at ${DateTime.now().toIso8601String()}');
    } catch (e) {
      print('Error sending typing indicator: $e');
    }
  }

  /// Test method to manually send a message (for debugging)
  Future<void> testSendMessage(String message, int chatId) async {
    print('🧪 === TEST MESSAGE SEND ===');
    print('🧪 Message: $message');
    print('🧪 Chat ID: $chatId');
    print('🧪 Event: message:send');
    await sendMessage(message, chatId);
    print('🧪 === TEST MESSAGE SEND COMPLETE ===');
  }

  /// Send read receipt
  Future<void> sendReadReceipt(String messageId) async {
    if (!_isConnected || _socket == null) return;

    try {
      final readData = {
        'type': 'read_receipt',
        'messageId': messageId,
        'chatId': _currentChatId,
      };

      _socket!.emit('read_receipt', readData);
    } catch (e) {
      print('Error sending read receipt: $e');
    }
  }

  /// Request chat list updates
  Future<void> requestChatList() async {
    if (!_isConnected || _socket == null) return;

    try {
      final requestData = {
        'type': 'get_chat_list',
      };

      _socket!.emit('get_chat_list', requestData);
    } catch (e) {
      print('Error requesting chat list: $e');
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    print('WebSocket error: $error');
    _isConnected = false;
    _connectionStatusController.add(false);

    // Attempt to reconnect
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    }
  }

  /// Handle WebSocket disconnection
  void _handleDisconnection() {
    print('WebSocket disconnected');
    _isConnected = false;
    _connectionStatusController.add(false);

    // Attempt to reconnect
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _scheduleReconnect();
    }
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    _reconnectAttempts++;
    final delay =
        Duration(seconds: _reconnectAttempts * 2); // Exponential backoff

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      print('Attempting to reconnect... (attempt $_reconnectAttempts)');
      if (_currentChatId != null) {
        connectToChat(chatId: _currentChatId!);
      } else {
        initializeConnection();
      }
    });
  }

  /// Disconnect from current chat
  Future<void> _disconnectFromChat() async {
    if (_socket != null && _currentChatId != null) {
      try {
        final disconnectData = {
          'type': 'leave_chat',
          'chatId': _currentChatId,
        };
        _socket!.emit('leave_chat', disconnectData);
      } catch (e) {
        print('Error disconnecting from chat: $e');
      }
    }
    _currentChatId = null;
    _isConnected = false;
  }

  /// Disconnect completely
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _disconnectFromChat();
    _socket?.disconnect();
    _socket = null;
    _isConnected = false;
    _connectionStatusController.add(false);
    print('Socket.IO disconnected completely');
  }

  /// Dispose resources
  void dispose() {
    print("Disposing WebSocketService");
    disconnect();
    _messageController.close();
    _notificationController.close();
    _chatListController.close();
    _connectionStatusController.close();
  }
}
