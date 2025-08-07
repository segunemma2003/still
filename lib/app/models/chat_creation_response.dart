import 'package:nylo_framework/nylo_framework.dart';

class ChatCreationResponse extends Model {
  static StorageKey key = "chat_creation_response";

  int? id;
  int? creatorId;
  String? name;
  String? type;
  bool? isPublic;
  String? partnerId;
  String? inviteCode;
  String? createdAt;
  String? updatedAt;
  List<Map<String, dynamic>>? messages;
  Map<String, dynamic>? partner;

  ChatCreationResponse({
    this.id,
    this.creatorId,
    this.name,
    this.type,
    this.isPublic,
    this.partnerId,
    this.inviteCode,
    this.createdAt,
    this.updatedAt,
    this.messages,
    this.partner,
  }) : super(key: key);

  ChatCreationResponse.fromJson(dynamic data) : super(key: key) {
    id = data['id'];
    creatorId = data['creatorId'];
    name = data['name'];
    type = data['type'];
    isPublic = data['isPublic'];
    partnerId = data['partnerId'];
    inviteCode = data['inviteCode'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    messages = data['messages'] != null
        ? List<Map<String, dynamic>>.from(data['messages'])
        : [];
    partner = data['partner'];
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
      'messages': messages,
      'partner': partner,
    };
  }

  // Helper methods
  String? get partnerUsername => partner?['username'];
  String? get partnerFirstName => partner?['firstName'];
  String? get partnerLastName => partner?['lastName'];
  int? get partnerIdInt => partner?['id'];
  String? get partnerStatus => partner?['status'];
}
