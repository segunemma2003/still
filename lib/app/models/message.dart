class Message {
  final int id;
  final int senderId;
  final int chatId;
  final String type;
  final String? text;
  final String? caption;

  final int? fileId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Sender sender;

  final bool isSent;
  final bool isDelivered;
  final bool isAudio;
  final String? audioDuration;

  Message({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.type,
    required this.isSent,
    required this.isDelivered,
    required this.isAudio,
    this.text,
    this.caption,
    this.fileId,
    this.audioDuration,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      chatId: json['chatId'],
      type: json['type'],
      text: json['text'],
      caption: json['caption'],
      fileId: json['fileId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sender: Sender.fromJson(json['sender']),
      isSent: true,
      isDelivered: true,
      isAudio: json['type'] == "AUDIO",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'chatId': chatId,
      'type': type,
      'text': text,
      'caption': caption,
      'fileId': fileId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sender': sender.toJson(),
      'isSent': isSent,
      'isDelivered': isDelivered,
      'isAudio': isAudio,
      'audioDuration': audioDuration,
    };
  }
}

class Sender {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;

  Sender({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
