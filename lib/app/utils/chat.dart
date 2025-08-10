import 'package:flutter_app/app/models/chat.dart';

String? formatTime(DateTime? time) {
  if (time == null) return null;

  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return 'now';
  }
}

String? formatMessageTime(DateTime? time) {
  if (time == null) return null;
  return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
}

String? getChatAvatar(Chat chat, String baseUrl) {
  String? avatar;

  if (chat.type == "PRIVATE") {
    avatar = chat.partner?.avatar;
  } else {
    avatar = chat.avatar;
  }
  if (avatar == null) {
    return avatar;
  }

  // If avatar does not start with http, prepend API_BASE_URL from .env
  if (!avatar.startsWith('http')) {
    avatar = '$baseUrl$avatar';
  }
  return avatar;
}
