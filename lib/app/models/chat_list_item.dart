import 'message.dart';
import 'chat_partner.dart';

class ChatListItem {
  final int id;
  final String name;
  final Message? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final String? avatar;
  final bool isOnline;
  final bool isGroup;
  final String type;
  final List<String> participants;
  final List<Message> messages;
  final Partner? partner;

  ChatListItem({
    required this.id,
    required this.name,
    required this.type,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.avatar,
    this.isOnline = false,
    this.isGroup = false,
    this.participants = const [],
    this.messages = const [],
    this.partner,
  });

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      id: json['id'],
      name: (json['type'] == 'CHANNEL')
          ? (json['name'] ?? 'Unknown')
          : (json['partner'] != null && json['partner']['username'] != null
              ? json['partner']['username']
              : 'Unknown'),
      lastMessage:
          (json['messages'] != null && (json['messages'] as List).isNotEmpty)
              ? Message.fromJson((json['messages'] as List).last)
              : null,
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      avatar: json['avatar'] != null ? json['avatar'] as String : null,
      isOnline: json['isOnline'] ?? false,
      isGroup: (json['type'] == 'CHANNEL'),
      type: json['type'] ?? 'PRIVATE',
      participants: List<String>.from(json['participants'] ?? []),
      messages: (json['messages'] != null)
          ? List<Message>.from(
              (json['messages'] as List).map((m) => Message.fromJson(m)))
          : [],
      partner:
          json['partner'] != null ? Partner.fromJson(json['partner']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage?.toJson(),
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'avatar': avatar,
      'isOnline': isOnline,
      'isGroup': isGroup,
      'participants': participants,
      'messages': messages.map((m) => m.toJson()).toList(),
      'partner': partner?.toJson(),
    };
  }

  ChatListItem copyWith({
    int? id,
    String? name,
    Message? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    String? avatar,
    bool? isOnline,
    bool? isGroup,
    List<String>? participants,
    List<Message>? messages,
    Partner? partner,
  }) {
    return ChatListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      isGroup: isGroup ?? this.isGroup,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      partner: partner ?? this.partner,
      type: this.type, // type is not nullable, so we keep it as is
    );
  }
}
