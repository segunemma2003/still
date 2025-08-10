import '/app/models/message.dart';

class ChatMessagesResponse {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final List<Message> messages;

  ChatMessagesResponse({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.messages,
  });

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessagesResponse(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      total: json['total'] as int,
      totalPages: json['totalPages'] as int,
      messages: (json['messages'] as List<dynamic>)
          .map((item) => Message.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'total': total,
      'totalPages': totalPages,
      'messages': messages,
    };
  }
}
