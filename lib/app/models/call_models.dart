class CallResponse {
  final String callToken;
  final int chatId;
  final String message;

  CallResponse({
    required this.callToken,
    required this.chatId,
    required this.message,
  });

  factory CallResponse.fromJson(Map<String, dynamic> json) {
    return CallResponse(
      callToken: json['callToken'] as String,
      chatId: json['chatId'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callToken': callToken,
      'chatId': chatId,
      'message': message,
    };
  }
}
