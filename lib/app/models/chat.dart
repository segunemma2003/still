class Chat {
  final int id;
  final String? name;
  final String type;
  final bool isPublic;
  final String? inviteCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatUser> users;

  Chat({
    required this.id,
    this.name,
    required this.type,
    required this.isPublic,
    this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      isPublic: json['isPublic'],
      inviteCode: json['inviteCode'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      users: (json['Users'] as List)
          .map((userJson) => ChatUser.fromJson(userJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isPublic': isPublic,
      'inviteCode': inviteCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'Users': users.map((user) => user.toJson()).toList(),
    };
  }

  // Helper method to get partner's username (excluding current user)
  String? getPartnerUsername(int currentUserId) {
    final partner = users.firstWhere(
      (user) => user.id != currentUserId,
      orElse: () => ChatUser(
        id: 0,
        username: 'Unknown',
        chatMember: ChatMember(
          id: 0,
          userId: 0,
          chatId: 0,
          isAdmin: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );
    return partner.username;
  }
}

class ChatUser {
  final int id;
  final String username;
  final ChatMember chatMember;

  ChatUser({
    required this.id,
    required this.username,
    required this.chatMember,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      username: json['username'],
      chatMember: ChatMember.fromJson(json['ChatMember']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'ChatMember': chatMember.toJson(),
    };
  }
}

class ChatMember {
  final int id;
  final int userId;
  final int chatId;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMember({
    required this.id,
    required this.userId,
    required this.chatId,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      id: json['id'],
      userId: json['userId'],
      chatId: json['chatId'],
      isAdmin: json['isAdmin'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'chatId': chatId,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
