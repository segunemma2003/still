import 'chat.dart';

class ChatListResponse {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final List<Chat> chats;

  ChatListResponse({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.chats,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      page: json['page'],
      pageSize: json['pageSize'],
      total: json['total'],
      totalPages: json['totalPages'],
      chats: (json['chats'] as List).map((c) => Chat.fromJson(c)).toList(),
    );
  }

  ChatListResponse copyWith({
    int? page,
    int? pageSize,
    int? total,
    int? totalPages,
    List<Chat>? chats,
  }) {
    return ChatListResponse(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'total': total,
      'totalPages': totalPages,
      'chats': chats.map((c) => c.toJson()).toList(),
    };
  }
}
