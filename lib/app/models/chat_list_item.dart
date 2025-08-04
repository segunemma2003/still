class ChatListItem {
  final int id;
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final String? avatar;
  final bool isOnline;
  final bool isGroup;
  final List<String> participants;

  ChatListItem({
    required this.id,
    required this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.avatar,
    this.isOnline = false,
    this.isGroup = false,
    this.participants = const [],
  });

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      avatar: json['avatar'],
      isOnline: json['isOnline'] ?? false,
      isGroup: json['isGroup'] ?? false,
      participants: List<String>.from(json['participants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'avatar': avatar,
      'isOnline': isOnline,
      'isGroup': isGroup,
      'participants': participants,
    };
  }

  ChatListItem copyWith({
    int? id,
    String? name,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    String? avatar,
    bool? isOnline,
    bool? isGroup,
    List<String>? participants,
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
    );
  }
}
