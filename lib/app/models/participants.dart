class Participant {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;
  final ChatMember chatMember;

  Participant({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    required this.chatMember,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      chatMember: ChatMember.fromJson(json['chatMember']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'chatMember': chatMember.toJson(),
    };
  }
}

class ChatMember {
  final int id;
  final int userId;
  final int chatId;
  final bool isAdmin;

  ChatMember({
    required this.id,
    required this.userId,
    required this.chatId,
    required this.isAdmin,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      id: json['id'] as int,
      userId: json['userId'] as int,
      chatId: json['chatId'] as int,
      isAdmin: json['isAdmin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'chatId': chatId,
      'isAdmin': isAdmin,
    };
  }
}
