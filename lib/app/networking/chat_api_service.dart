import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/chat.dart';
import '/app/models/chat_list_item.dart';
import '/app/networking/api_service.dart';

class ChatApiService extends ApiService {
  ChatApiService({BuildContext? buildContext})
      : super(buildContext: buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  /// Get list of all chats for the current user
  Future<List<ChatListItem>?> getChatList() async {
    return await network<List<ChatListItem>>(
      request: (request) => request.get("/chat/list"),
    );
  }

  /// Create or get a private chat with a partner
  Future<Chat?> createPrivateChat({required int partnerId}) async {
    return await network<Chat>(
      request: (request) => request.post(
        "/chat",
        data: {
          "type": "PRIVATE",
          "partnerId": partnerId.toString(),
        },
      ),
    );
  }

  /// Get chat messages (for loading previous messages)
  Future<List<Map<String, dynamic>>?> getChatMessages({
    required int chatId,
    int? limit = 50,
    int? offset = 0,
  }) async {
    return await network<List<Map<String, dynamic>>>(
      request: (request) => request.get(
        "/chat/$chatId/messages",
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      ),
    );
  }

  /// Send a message to a chat (fallback when WebSocket is not available)
  Future<Map<String, dynamic>?> sendMessage({
    required int chatId,
    required String message,
  }) async {
    return await network<Map<String, dynamic>>(
      request: (request) => request.post(
        "/chat/$chatId/messages",
        data: {
          "message": message,
        },
      ),
    );
  }

  /// Mark messages as read
  Future<bool?> markMessagesAsRead({
    required int chatId,
    List<String>? messageIds,
  }) async {
    return await network<bool>(
      request: (request) => request.post(
        "/chat/$chatId/read",
        data: {
          if (messageIds != null) "messageIds": messageIds,
        },
      ),
    );
  }

  /// Get chat details
  Future<Chat?> getChatDetails({required int chatId}) async {
    return await network<Chat>(
      request: (request) => request.get("/chat/$chatId"),
    );
  }

  /// Delete a chat
  Future<bool?> deleteChat({required int chatId}) async {
    return await network<bool>(
      request: (request) => request.delete("/chat/$chatId"),
    );
  }

  /// Search chats
  Future<List<ChatListItem>?> searchChats({required String query}) async {
    return await network<List<ChatListItem>>(
      request: (request) => request.get(
        "/chat/search",
        queryParameters: {"q": query},
      ),
    );
  }
}
