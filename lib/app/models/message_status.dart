class MessageStatus {
  final int id;
  final String status;
  final int userId;
  final int messageId;

  MessageStatus({
    required this.id,
    required this.status,
    required this.userId,
    required this.messageId,
  });

  factory MessageStatus.fromJson(Map<String, dynamic> json) {
    return MessageStatus(
      id: json['id'] as int,
      status: json['status'] as String,
      userId: json['userId'] as int,
      messageId: json['messageId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'userId': userId,
      'messageId': messageId,
    };
  }
}
