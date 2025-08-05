import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/models/message.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/chat.dart';
import '/app/models/chat_list_item.dart';
import '/app/networking/chat_api_service.dart';
import '/app/networking/websocket_service.dart';
import '/resources/pages/video_call_page.dart';
import '/resources/pages/voice_call_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';

class ChatScreenPage extends NyStatefulWidget {
  static RouteView path = ("/chat-screen", (_) => ChatScreenPage());

  ChatScreenPage({super.key}) : super(child: () => _ChatScreenPageState());
}

class _ChatScreenPageState extends NyPage<ChatScreenPage>
    with HasApiService<ChatApiService> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showMediaPicker = false;
  bool _isPlaying = false;
  bool _hasText = false;

  // Chat data
  Chat? _chat;
  String _userName = 'Ahmad';
  String? _userImage;
  bool _isOnline = false;
  bool _isVerified = false;
  bool _isTyping = false;
  Set<int> _typingUsers = {};

  // WebSocket integration
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;
  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
  bool _isWebSocketConnected = false;

  List<Message> messages = [];
  int? _currentUserId;
  @override
  get init => () async {
        print("Init method called"); // Debug
        _messageController.addListener(_onTextChanged);
        // _messageController.addListener(listener)
        // Get current user id from Auth
        try {
          final userData = await Auth.data();
          if (userData != null && userData['id'] != null) {
            _currentUserId = userData['id'] is int
                ? userData['id']
                : int.tryParse(userData['id'].toString());
            print('Current user id: [38;5;246m$_currentUserId[0m');
          }
        } catch (e) {
          print('Error fetching user id: $e');
        }

        // Retrieve chat data from navigation
        final navigationData = data();
        if (navigationData != null) {
          _chat = navigationData['chat'] as Chat?;
          print('Chat data from navigation: $_chat');
          print(
              'Chat list item from navigation: ${navigationData['chatListItem']}');
          final chatListItem = navigationData['chatListItem'] as ChatListItem?;

          // Use chat details if available, otherwise use chat list item
          if (_chat != null) {
            _userName = _chat!.name ?? 'Unknown User';
            _userImage = null;
            _isOnline = _chat!.partner?.status == 'online';
            _isVerified = false;
          } else if (chatListItem != null) {
            _userName = chatListItem.name;
            _userImage = chatListItem.avatar;
            _isOnline = _chat!.partner?.status == 'online';
            _isVerified = false;
          } else {
            _userName = navigationData['userName'] as String? ?? 'Ahmad';
            _userImage = navigationData['userImage'] as String?;
            _isOnline = false;
            _isVerified = navigationData['isVerified'] as bool? ?? false;
          }

          print('Chat data loaded: ${_chat?.id}');
          print('User name: $_userName');
          print('Is online: $_isOnline');

          // Load previous messages if we have a chat
          if (_chat != null) {
            await _loadPreviousMessages();
            await _connectToWebSocket();
          }
        } else {
          routeToAuthenticatedRoute();
        }
      };

  // Connect to WebSocket
  Future<void> _connectToWebSocket() async {
    if (_chat != null) {
      await WebSocketService().connectToChat(chatId: _chat!.id.toString());
      _isWebSocketConnected = WebSocketService().isConnected;

      // Listen for incoming messages
      _wsSubscription = WebSocketService().messageStream.listen((messageData) {
        _handleIncomingMessage(messageData);
      });
      _notificationSubscription =
          WebSocketService().notificationStream.listen((notificationData) {
        _handleIncomingNotification(notificationData);
      });
    }
  }

  // Handle incoming notifications
  Future<void> _handleIncomingNotification(
      Map<String, dynamic> notificationData) async {
    print('Handling incoming notification: $notificationData');
    final userData = await Auth.data();

    if (notificationData['action'] == 'user:disconnected') {
      // Handle chat update notifications
      if (_chat != null && _chat!.partner != null) {
        if (notificationData['userId'] == _chat!.partner!.id) {
          setState(() {
            _isOnline = false;
          });
        }
      }
    } else if (notificationData['action'] == 'user:connected') {
      // Handle user connected notification
      if (_chat != null && _chat!.partner != null) {
        if (notificationData['userId'] == _chat!.partner!.id) {
          setState(() {
            _isOnline = true;
          });
        }
      }
    } else if (notificationData['action'] == 'typing:start') {
      if (notificationData['chatId'] == _chat?.id &&
          notificationData['userId'] != userData?['id']) {
        final newTypingUsers = _typingUsers.toSet();
        newTypingUsers.add(notificationData['userId']);

        setState(() {
          _typingUsers = newTypingUsers;
        });
      }
    } else if (notificationData['action'] == 'typing:stop' &&
        notificationData['userId'] != userData?['id']) {
      if (notificationData['chatId'] == _chat?.id) {
        final newTypingUsers = _typingUsers.toSet();
        newTypingUsers.remove(notificationData['userId']);
        setState(() {
          _typingUsers = newTypingUsers;
        });
      }
    }
  }

  Future<void> _loadPreviousMessages() async {
    if (_chat != null) {
      try {
        // final previousMessages = _chat.messages;
        // await apiService.getChatMessages(chatId: _chat!.id);
        if (_chat != null) {
          setState(() {
            // Convert API messages to Message objects
            messages = _chat!.messages;
          });
          // messages = _chat!.messages;
        }
      } catch (e) {
        print('Error loading previous messages: $e');
      }
    }
  }

  String _formatMessageTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  // Handle incoming WebSocket messages
  void _handleIncomingMessage(Map<String, dynamic> messageData) {
    // This runs on the main thread and won't block UI
    print('Handling incoming message: $messageData');

    setState(() {
      final action = messageData['action'];

      if (action != null && action == 'delete') {
        final index = messages.indexWhere((msg) => msg.id == messageData['id']);
        // Remove message if action is delete
        print("Message deleted: ${messageData['id']}");
        print("Removing message at index: $index");
        if (index != -1) {
          messages.removeAt(index);
        }
      } else {
        Message newMessage = Message.fromJson(messageData);
        final index = messages.indexWhere((msg) => msg.id == newMessage.id);

        if (index != -1) {
          messages[index] = newMessage;
        } else {
          messages.add(newMessage);
        }
      }
    });

    _scrollToBottom();
  }

  void _onTextChanged() {
    bool hasText = _messageController.text.trim().isNotEmpty;

    if (hasText != _hasText) {
      WebSocketService().sendTypingIndicator(
        hasText,
        _chat!.id,
      );
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();

    // Clean up WebSocket resources
    _wsSubscription?.cancel();
    _notificationSubscription?.cancel();
    WebSocketService().disconnect();

    super.dispose();
  }

  Future<void> _pickFileOnWeb() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      print(fileName);
      // Use fileBytes or fileName as needed
    }
    // Implement file picking for web
  }

  void _toggleMediaPicker() {
    if (kIsWeb) {
      _pickFileOnWeb();
      setState(() {
        _showMediaPicker = false;
      });
    } else {
      setState(() {
        _showMediaPicker = !_showMediaPicker;
      });
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();
      print("Sending message: $messageText");
      // Add message to UI immediately for better UX
      // setState(() {
      //   messages.add(Message(
      //     text: messageText,
      //     time:
      //         "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
      //     isSent: true,
      //     isDelivered: false,
      //   ));
      // });

      _messageController.clear();
      _scrollToBottom();

      // Send via WebSocket if connected (real-time)
      if (_isWebSocketConnected) {
        WebSocketService().sendMessage(messageText, _chat!.id);
        print('Message sent via WebSocket');

        // Update as delivered after a short delay
        // Future.delayed(const Duration(milliseconds: 500), () {
        //   setState(() {
        //     if (messages.isNotEmpty) {
        //       final lastMessage = messages.last;
        //       messages[messages.length - 1] = Message(
        //         text: lastMessage.text,
        //         time: lastMessage.time,
        //         isSent: true,
        //         isDelivered: true,
        //         isAudio: lastMessage.isAudio,
        //         audioDuration: lastMessage.audioDuration,
        //       );
        //     }
        //   });
        // });
      }
      // Fallback to API if WebSocket not connected
      else if (_chat != null) {
        try {
          final result = await apiService.sendMessage(
            chatId: _chat!.id,
            message: messageText,
          );

          if (result != null) {
            print('Message sent via API');
            // Update the last message as delivered
            // setState(() {
            //   if (messages.isNotEmpty) {
            //     final lastMessage = messages.last;
            //     messages[messages.length - 1] = Message(
            //       text: lastMessage.text,
            //       time: lastMessage.time,
            //       isSent: true,
            //       isDelivered: true,
            //       isAudio: lastMessage.isAudio,
            //       audioDuration: lastMessage.audioDuration,
            //     );
            //   }
            // });
          }
        } catch (e) {
          print('Error sending message via API: $e');
        }
      } else {
        print('No WebSocket connection or chat available');
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen SVG background
          Positioned.fill(
            child: SvgPicture.asset(
              'public/images/chatBackround.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Column(
            children: [
              // AppBar with semi-transparent background
              Container(
                color: Color(0xFF1C212C).withOpacity(0.9),
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    height: kToolbarHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Container(
                            width: 18,
                            height: 18,
                            child: SvgPicture.asset(
                              'public/images/back_arrow.svg',
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                Color(0xFFE8E7EA),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          // TODO: Change chack to Navigator.pop
                          // onPressed: () => Navigator.pop(context),
                          onPressed: () => routeToAuthenticatedRoute(),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade700,
                          ),
                          child: ClipOval(
                            child: _userImage != null
                                ? Image.asset(
                                    _userImage!,
                                    fit: BoxFit.cover,
                                  ).localAsset()
                                : Icon(
                                    Icons.person,
                                    color: Colors.grey.shade500,
                                    size: 20,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // This centers the column content
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _userName,
                                textAlign: TextAlign
                                    .center, // Add this to center the text horizontally
                                style: const TextStyle(
                                  color: Color(0xFFE8E7EA),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // This centers the row content
                                children: [
                                  if (_typingUsers.isEmpty)
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: _isOnline
                                            ? const Color(0xFF2ECC71)
                                            : Colors.grey.shade500,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _typingUsers.isNotEmpty
                                        ? 'Typing...'
                                        : (_isOnline ? 'Online' : 'Offline'),
                                    style: TextStyle(
                                      color: _typingUsers.isNotEmpty
                                          ? const Color(0xFF3498DB)
                                          : (_isOnline
                                              ? const Color(0xFF2ECC71)
                                              : Colors.grey.shade500),
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => routeTo(VideoCallPage.path),
                              child: Container(
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  'public/images/video_call.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    Color(0xFFE8E7EA),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12), // Exact spacing you want
                            GestureDetector(
                              onTap: () => routeTo(VoiceCallPage.path),
                              child: Container(
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  'public/images/voice_call.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    Color(0xFFE8E7EA),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),

              // Chat content with floating Today header
              Expanded(
                child: Stack(
                  children: [
                    // Messages with padding for floating header
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0), // Space for floating "Today"
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessage(messages[index]);
                        },
                      ),
                    ),

                    // Floating "Today" header
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF1C212C).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Today',
                            style: TextStyle(
                              color: Color(0xFFE8E7EA),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Transparent input area with blur effect
                    if (!_showMediaPicker)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: SafeArea(
                                top: false,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: _toggleMediaPicker,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          'public/images/add.svg',
                                          width: 18,
                                          height: 18,
                                          colorFilter: ColorFilter.mode(
                                            Color(0xFFE8E7EA),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 120, // Limit max height
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF0F131B)
                                              .withValues(alpha: .4),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: TextField(
                                          controller: _messageController,
                                          maxLines:
                                              null, // Allow unlimited lines
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFE8E7EA)),
                                          decoration: InputDecoration(
                                            hintText: 'Type a message...',
                                            hintStyle: TextStyle(
                                              color: Color(0xFFE8E7EA)
                                                  .withOpacity(0.7),
                                              fontSize: 16,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            suffixIcon: _hasText
                                                ? GestureDetector(
                                                    onTap: _sendMessage,
                                                    child: Container(
                                                      width: 32,
                                                      height: 32,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 4),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.send,
                                                        color:
                                                            Color(0xFFE8E7EA),
                                                        size: 20,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 32,
                                                    height: 32,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.transparent,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.mic,
                                                      color: Color(0xFFE8E7EA),
                                                      size: 20,
                                                    ),
                                                  ),
                                          ),
                                          onSubmitted: (_) => _sendMessage(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    if (!_hasText)
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            'public/images/camera_icons.svg',
                                            width: 18,
                                            height: 18,
                                            colorFilter: ColorFilter.mode(
                                              Color(0xFFE8E7EA),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Media picker overlay
                    if (_showMediaPicker)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildMediaPicker(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    // Determine if this message was sent by the current user
    final bool isSentByMe =
        _currentUserId != null && message.senderId == _currentUserId;
    return Container(
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 4),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe) const SizedBox(width: 10),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSentByMe
                    ? const Color(0xFF3498DB)
                    : const Color(0xFF404040),
                borderRadius: isSentByMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(4),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isAudio)
                    Row(
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.audioDuration ?? '0:00',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      message.type == "TEXT"
                          ? (message.text ?? '')
                          : (message.caption ?? ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.createdAt.toIso8601String().substring(11, 16),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      if (isSentByMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isDelivered ? Icons.done_all : Icons.done,
                          color: message.isDelivered
                              ? const Color(0xFF3498DB)
                              : Colors.white.withOpacity(0.7),
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isSentByMe) const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildAudioMessage(Message message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isPlaying = !_isPlaying;
            });
            HapticFeedback.lightImpact();
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E7EA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: const Color(0xFF3498DB),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              // Audio waveform
              Container(
                height: 20,
                child: Row(
                  children: List.generate(20, (index) {
                    double height = [
                      0.3,
                      0.7,
                      0.5,
                      0.9,
                      0.4,
                      0.8,
                      0.6,
                      0.3,
                      0.7,
                      0.5,
                      0.9,
                      0.4,
                      0.8,
                      0.6,
                      0.3,
                      0.7,
                      0.5,
                      0.9,
                      0.4,
                      0.8
                    ][index];
                    return Container(
                      width: 2,
                      height: 20 * height,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8E7EA).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    message.audioDuration ?? "0:00",
                    style: TextStyle(
                      color: Color(0xFFE8E7EA).withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        message.createdAt.toIso8601String().substring(11, 16),
                        style: TextStyle(
                          color: Color(0xFFE8E7EA).withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      if (message.isSent) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 16,
                          height: 16,
                          child: Image.asset(
                            message.isDelivered
                                ? 'double_check.png'
                                : 'single_check.png',
                            width: 16,
                            height: 16,
                            color: message.isDelivered
                                ? const Color(0xFF00BCD4)
                                : Color(0xFFE8E7EA).withOpacity(0.7),
                          ).localAsset(),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPicker() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1B1C1D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => _toggleMediaPicker(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFFE8E7EA),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Recent',
                  style: TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Handle manage action
                  },
                  child: const Text(
                    'Manage',
                    style: TextStyle(
                      color: Color(0xFF3498DB),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content area (takes most of the space)
          Expanded(
            child: _MediaPickerContent(),
          ),

          // Tab indicator at bottom
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF3498DB),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaPickerContent extends StatefulWidget {
  @override
  _MediaPickerContentState createState() => _MediaPickerContentState();
}

class _MediaPickerContentState extends State<_MediaPickerContent> {
  int _selectedTabIndex = 0;

  final List<MediaTab> _tabs = [
    MediaTab(
      title: 'Gallery',
      icon: Icons.photo_library,
      content: _GalleryContent(),
    ),
    MediaTab(
      title: 'File',
      icon: Icons.folder,
      content: _FileContent(),
    ),
    MediaTab(
      title: 'Location',
      icon: Icons.location_on,
      content: _LocationContent(),
    ),
    MediaTab(
      title: 'Conversion',
      icon: Icons.transform,
      content: _ConversionContent(),
    ),
    MediaTab(
      title: 'Contact',
      icon: Icons.contact_phone,
      content: _ContactContent(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab content (takes most of the space)
        Expanded(
          child: _tabs[_selectedTabIndex].content,
        ),

        // Tab buttons at bottom
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = index == _selectedTabIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isSelected
                              ? const Color(0xFF3498DB)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab.icon,
                          color: isSelected
                              ? const Color(0xFF3498DB)
                              : const Color(0xFF6E6E6E),
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.title,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF3498DB)
                                : const Color(0xFF6E6E6E),
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class MediaTab {
  final String title;
  final IconData icon;
  final Widget content;

  MediaTab({
    required this.title,
    required this.icon,
    required this.content,
  });
}

// Gallery Content Widget
class _GalleryContent extends StatefulWidget {
  @override
  _GalleryContentState createState() => _GalleryContentState();
}

class _GalleryContentState extends State<_GalleryContent> {
  List<AssetEntity> _galleryImages = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadGallery();
  }

  Future<void> _requestPermissionAndLoadGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request photo library permission
      if (kIsWeb) {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);

        if (result != null) {
          Uint8List? fileBytes = result.files.first.bytes;
          String fileName = result.files.first.name;
          print(fileName);
          // Use fileBytes or fileName as needed
        }
      } else {
        final permission = await Permission.photos.request();
        if (permission.isGranted) {
          setState(() {
            _hasPermission = true;
          });
          await _loadGalleryImages();
        } else {
          setState(() {
            _hasPermission = false;
            _isLoading = false;
          });
          print('Photo library permission denied');
        }
      }
    } catch (e) {
      print('Error requesting permission: $e');
      setState(() {
        _hasPermission = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadGalleryImages() async {
    try {
      // Get the photo library
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isNotEmpty) {
        // Get the first album (usually "All Photos")
        final AssetPathEntity album = albums.first;

        // Get assets from the album
        final List<AssetEntity> assets = await album.getAssetListRange(
          start: 0,
          end: 50, // Load first 50 images
        );

        setState(() {
          _galleryImages = assets;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('No albums found');
      }
    } catch (e) {
      print('Error loading gallery images: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        print('Selected image from gallery: ${image.path}');
        // Handle the selected image
        // You can send it to the chat or process it further
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  Future<void> _takePhotoWithCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        print('Photo taken with camera: ${photo.path}');
        // Handle the captured photo
        // You can send it to the chat or process it further
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: const Color(0xFF3498DB),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading gallery...',
              style: TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (!_hasPermission) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_library,
              color: Color(0xFF6E6E6E),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gallery Permission Required',
              style: TextStyle(
                color: Color(0xFFE8E7EA),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please grant photo library access to view your gallery',
              style: TextStyle(
                color: Color(0xFF6E6E6E),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _requestPermissionAndLoadGallery,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3498DB),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Gallery header with camera button
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Gallery (${_galleryImages.length})',
                  style: const TextStyle(
                    color: Color(0xFFE8E7EA),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _takePhotoWithCamera,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Gallery grid
        Expanded(
          child: _galleryImages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_library,
                        color: Color(0xFF6E6E6E),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Images Found',
                        style: TextStyle(
                          color: Color(0xFFE8E7EA),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your gallery appears to be empty',
                        style: TextStyle(
                          color: Color(0xFF6E6E6E),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: _galleryImages.length,
                  itemBuilder: (context, index) {
                    final asset = _galleryImages[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle image selection
                        print('Selected image: ${asset.id}');
                        // You can implement image sending logic here
                      },
                      onLongPress: () {
                        // Open gallery picker on long press
                        _pickImageFromGallery();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              // Real gallery image
                              FutureBuilder<Uint8List?>(
                                future: asset.thumbnailData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      color: Colors.grey.shade700,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF3498DB),
                                        ),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return Container(
                                      color: Colors.grey.shade700,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 32,
                                      ),
                                    );
                                  }

                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  );
                                },
                              ),
                              // Selection overlay
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// File Content Widget
class _FileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file,
                color: const Color(0xFF3498DB),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Document ${index + 1}.pdf',
                      style: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(index + 1) * 100} KB',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Location Content Widget
class _LocationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: const Color(0xFFE74C3C),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location ${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '123 Main St, City, Country',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Conversion Content Widget
class _ConversionContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.transform,
                color: const Color(0xFFF39C12),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conversion ${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Currency, Unit, etc.',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Contact Content Widget
class _ContactContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade700,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'image${(index % 11) + 1}.png',
                    fit: BoxFit.cover,
                  ).localAsset(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact ${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFFE8E7EA),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '+1 234 567 890${index + 1}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
