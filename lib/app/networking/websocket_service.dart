import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nylo_framework/nylo_framework.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocket? _webSocket;
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

  /// Initialize WebSocket connection for general notifications and chat list updates
  Future<void> initializeConnection() async {
    if (_isConnecting || _isConnected) return;

    _isConnecting = true;
    try {
      final baseUrl = getEnv('API_BASE_URL').replaceFirst('http', 'ws');
      final wsUrl = '$baseUrl/ws/user';

      _webSocket = await WebSocket.connect(wsUrl);
      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;

      _connectionStatusController.add(true);
      print('WebSocket connected successfully for user notifications');

      // Listen for incoming messages
      _webSocket!.listen(
        (data) => _handleIncomingMessage(data),
        onError: (error) => _handleError(error),
        onDone: () => _handleDisconnection(),
      );

      // Send authentication message
      await _sendAuthMessage();
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
      final baseUrl = getEnv('API_BASE_URL').replaceFirst('http', 'ws');
      final wsUrl = '$baseUrl/ws/chat/$chatId';

      _webSocket = await WebSocket.connect(wsUrl);
      _currentChatId = chatId;
      _isConnected = true;
      _reconnectAttempts = 0;

      _connectionStatusController.add(true);
      print('WebSocket connected to chat $chatId');

      // Listen for incoming messages
      _webSocket!.listen(
        (data) => _handleIncomingMessage(data),
        onError: (error) => _handleError(error),
        onDone: () => _handleDisconnection(),
      );

      // Send authentication message
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
        _webSocket?.add(jsonEncode(authMessage));
      }
    } catch (e) {
      print('Error sending auth message: $e');
    }
  }

  /// Handle incoming messages and route them to appropriate streams
  void _handleIncomingMessage(dynamic data) {
    try {
      final messageData = jsonDecode(data);
      final messageType = messageData['type'];

      switch (messageType) {
        case 'message':
          _messageController.add(messageData);
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
          print('Unknown message type: $messageType');
      }
    } catch (e) {
      print('Error parsing incoming message: $e');
    }
  }

  /// Send a message to the current chat
  Future<void> sendMessage(String message) async {
    if (!_isConnected || _webSocket == null) {
      print('WebSocket not connected');
      return;
    }

    try {
      final messageData = {
        'type': 'message',
        'content': message,
        'chatId': _currentChatId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _webSocket!.add(jsonEncode(messageData));
      print('Message sent: $message');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(bool isTyping) async {
    if (!_isConnected || _webSocket == null) return;

    try {
      final typingData = {
        'type': 'typing',
        'isTyping': isTyping,
        'chatId': _currentChatId,
      };

      _webSocket!.add(jsonEncode(typingData));
    } catch (e) {
      print('Error sending typing indicator: $e');
    }
  }

  /// Send read receipt
  Future<void> sendReadReceipt(String messageId) async {
    if (!_isConnected || _webSocket == null) return;

    try {
      final readData = {
        'type': 'read_receipt',
        'messageId': messageId,
        'chatId': _currentChatId,
      };

      _webSocket!.add(jsonEncode(readData));
    } catch (e) {
      print('Error sending read receipt: $e');
    }
  }

  /// Request chat list updates
  Future<void> requestChatList() async {
    if (!_isConnected || _webSocket == null) return;

    try {
      final requestData = {
        'type': 'get_chat_list',
      };

      _webSocket!.add(jsonEncode(requestData));
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
    if (_webSocket != null) {
      try {
        final disconnectData = {
          'type': 'leave_chat',
          'chatId': _currentChatId,
        };
        _webSocket!.add(jsonEncode(disconnectData));
        await _webSocket!.close();
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
    _webSocket?.close();
    _webSocket = null;
    _isConnected = false;
    _connectionStatusController.add(false);
    print('WebSocket disconnected completely');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _notificationController.close();
    _chatListController.close();
    _connectionStatusController.close();
  }
}
