import 'package:flutter_app/app/models/message_status.dart';

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

  final bool isSent; // Deprecated, use isRead
  bool isDelivered;
  bool isRead;
  final bool isAudio;
  final String? audioDuration;

  final int? referenceId; // Optional reference ID for replies or quotes
  final List<MessageStatus> statuses;

  Message({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.type,
    required this.isRead,
    required this.isDelivered,
    required this.isAudio,
    required this.statuses,
    required this.isSent,
    this.referenceId,
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
      referenceId: json['referenceId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sender: Sender.fromJson(json['sender']),
      statuses: (json['statuses'] as List)
          .map((status) => MessageStatus.fromJson(status))
          .toList(),
      isSent: json['isSent'] ?? true,
      audioDuration: json['audioDuration'],
      isRead: json['isRead'] ?? false,
      isDelivered: json['isDelivered'] ?? false,
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
      'isSent': isRead,
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
  final String? avatar;
  Sender({
    required this.id,
    required this.username,
    this.avatar,
    this.firstName,
    this.lastName,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      avatar: json['avatar'],
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
