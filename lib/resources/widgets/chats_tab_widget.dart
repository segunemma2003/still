import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/chat_list_item.dart';
import '/app/networking/chat_api_service.dart';
import '/app/networking/websocket_service.dart';
import '/resources/pages/chat_screen_page.dart';
import '/resources/widgets/alphabet_scroll_view_widget.dart';

class ChatsTab extends StatefulWidget {
  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab>
    with HasApiService<ChatApiService> {
  List<ChatListItem> _chatList = [];
  bool _isLoading = true;
  String _searchQuery = '';
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
    _loadChatList();
  }

  Future<void> _initializeWebSocket() async {
    // Initialize WebSocket connection for notifications
    await WebSocketService().initializeConnection();

    // Listen for chat list updates
    _wsSubscription = WebSocketService().chatListStream.listen((data) {
      _handleChatListUpdate(data);
    });

    // Listen for connection status
    _connectionSubscription =
        WebSocketService().connectionStatusStream.listen((isConnected) {
      if (isConnected) {
        // Request updated chat list when reconnected
        WebSocketService().requestChatList();
      }
    });
  }

  Future<void> _loadChatList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final chatList = await apiService.getChatList();
      if (chatList != null) {
        setState(() {
          _chatList = chatList;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading chat list: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleChatListUpdate(Map<String, dynamic> data) {
    // Handle real-time chat list updates from WebSocket
    if (data['type'] == 'chat_list_update') {
      final updatedChat = ChatListItem.fromJson(data['chat']);

      setState(() {
        final index = _chatList.indexWhere((chat) => chat.id == updatedChat.id);
        if (index != -1) {
          _chatList[index] = updatedChat;
        } else {
          _chatList.insert(0, updatedChat); // Add new chat at top
        }

        // Sort by last message time
        _chatList.sort((a, b) {
          final aTime = a.lastMessageTime ?? DateTime(1900);
          final bTime = b.lastMessageTime ?? DateTime(1900);
          return bTime.compareTo(aTime);
        });
      });
    }
  }

  Future<void> _onChatTap(ChatListItem chat) async {
    try {
      // Get chat details if needed
      final chatDetails = await apiService.getChatDetails(chatId: chat.id);

      if (chatDetails != null) {
        // Navigate to chat screen
        routeTo(ChatScreenPage.path, data: {
          'chat': chatDetails,
          'chatListItem': chat,
        });
      } else {
        // Fallback to basic chat info
        routeTo(ChatScreenPage.path, data: {
          'chatListItem': chat,
        });
      }
    } catch (e) {
      print('Error opening chat: $e');
      // Still navigate with basic info
      routeTo(ChatScreenPage.path, data: {
        'chatListItem': chat,
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<ChatListItem> get _filteredChatList {
    if (_searchQuery.isEmpty) {
      return _chatList;
    }

    return _chatList.where((chat) {
      return chat.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (chat.lastMessage
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search chats...',
              hintStyle: const TextStyle(color: Color(0xFF6E6E6E)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6E6E6E)),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: const TextStyle(color: Color(0xFFE8E7EA)),
          ),
        ),

        // Chat list
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3498DB),
                  ),
                )
              : _filteredChatList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Color(0xFF6E6E6E),
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No chats yet'
                                : 'No chats found',
                            style: const TextStyle(
                              color: Color(0xFFE8E7EA),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Start a conversation to see your chats here'
                                : 'Try a different search term',
                            style: const TextStyle(
                              color: Color(0xFF6E6E6E),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredChatList.length,
                      itemBuilder: (context, index) {
                        final chat = _filteredChatList[index];
                        return _buildChatItem(chat);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildChatItem(ChatListItem chat) {
    return GestureDetector(
      onTap: () => _onChatTap(chat),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade700,
              ),
              child: chat.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        chat.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            chat.isGroup ? Icons.group : Icons.person,
                            color: Colors.grey.shade500,
                            size: 24,
                          );
                        },
                      ),
                    )
                  : Icon(
                      chat.isGroup ? Icons.group : Icons.person,
                      color: Colors.grey.shade500,
                      size: 24,
                    ),
            ),

            const SizedBox(width: 12),

            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: const TextStyle(
                            color: Color(0xFFE8E7EA),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.lastMessageTime != null)
                        Text(
                          _formatTime(chat.lastMessageTime!),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage ?? 'No messages yet',
                          style: TextStyle(
                            color: chat.unreadCount > 0
                                ? const Color(0xFFE8E7EA)
                                : Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3498DB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
