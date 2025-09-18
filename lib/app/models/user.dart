import 'package:nylo_framework/nylo_framework.dart';

class User extends Model {
  int? id;
  String? username;
  String? email;
  String? phone;
  String? accessToken;
  String? avatar;
  static StorageKey key = 'user';

  User() : super(key: key);

  User.fromJson(dynamic data) {
    id = data['id'];
    username = data['username'];
    email = data['email'];
    phone = data['phone'];
    accessToken = data['accessToken'];
    avatar = data['avatar'];
  }

  @override
  toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone": phone,
        "accessToken": accessToken,
        "avatar": avatar,
      };

  // Helper method to check if user is authenticated
  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;
}

class UploadAvatarResponse {
  String? id;
  String? filename;
  String? url;

  UploadAvatarResponse({this.id, this.filename, this.url});

  UploadAvatarResponse.fromJson(dynamic data) {
    id = data['id'];
    filename = data['filename'];
    url = data['url'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "filename": filename,
        "url": url,
      };
}