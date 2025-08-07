import 'package:nylo_framework/nylo_framework.dart';

class ChatInfo extends Model {
  static StorageKey key = "chat_info";

  int? id;
  int? creatorId;
  String? name;
  String? type;
  bool? isPublic;
  String? partnerId;
  String? inviteCode;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? partner;
  List<Map<String, dynamic>>? messages;

  ChatInfo({
    this.id,
    this.creatorId,
    this.name,
    this.type,
    this.isPublic,
    this.partnerId,
    this.inviteCode,
    this.createdAt,
    this.updatedAt,
    this.partner,
    this.messages,
  }) : super(key: key);

  ChatInfo.fromJson(dynamic data) : super(key: key) {
    id = data['id'];
    creatorId = data['creatorId'];
    name = data['name'];
    type = data['type'];
    isPublic = data['isPublic'];
    partnerId = data['partnerId'];
    inviteCode = data['inviteCode'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    partner = data['partner'];
    messages = data['messages'] != null
        ? List<Map<String, dynamic>>.from(data['messages'])
        : [];
  }

  @override
  toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'name': name,
      'type': type,
      'isPublic': isPublic,
      'partnerId': partnerId,
      'inviteCode': inviteCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'partner': partner,
      'messages': messages,
    };
  }

  // Helper methods
  String? get partnerUsername => partner?['username'];
  String? get partnerFirstName => partner?['firstName'];
  String? get partnerLastName => partner?['lastName'];
  int? get partnerIdInt => partner?['id'];

  // Get the last message
  Map<String, dynamic>? get lastMessage {
    if (messages != null && messages!.isNotEmpty) {
      return messages!.last;
    }
    return null;
  }

  // Get message text or media indicator
  String get messagePreview {
    final lastMsg = lastMessage;
    if (lastMsg == null) return '';

    final messageType = lastMsg['type'];
    if (messageType == 'TEXT') {
      return lastMsg['text'] ?? '';
    } else {
      // Return appropriate media emoji based on type
      switch (messageType) {
        case 'IMAGE':
          return '📷';
        case 'VIDEO':
          return '🎥';
        case 'AUDIO':
          return '🎵';
        case 'FILE':
          return '📄';
        case 'LOCATION':
          return '📍';
        default:
          return '📎';
      }
    }
  }

  // Get message time
  String get messageTime {
    final lastMsg = lastMessage;
    if (lastMsg == null) return '';

    final createdAt = lastMsg['createdAt'];
    if (createdAt == null) return '';

    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'now';
      }
    } catch (e) {
      return '';
    }
  }

  // Check if message is from partner (not current user)
  bool get isMessageFromPartner {
    final lastMsg = lastMessage;
    if (lastMsg == null) return false;

    // You might need to get current user ID from Auth
    // For now, we'll assume if senderId != creatorId, it's from partner
    return lastMsg['senderId'] != creatorId;
  }
}
