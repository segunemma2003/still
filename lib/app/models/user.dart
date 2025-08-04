import 'package:nylo_framework/nylo_framework.dart';

class User extends Model {
  int? id;
  String? username;
  String? email;
  String? phone;
  String? accessToken;

  static StorageKey key = 'user';

  User() : super(key: key);

  User.fromJson(dynamic data) {
    id = data['id'];
    username = data['username'];
    email = data['email'];
    phone = data['phone'];
    accessToken = data['accessToken'];
  }

  @override
  toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone": phone,
        "accessToken": accessToken,
      };

  // Helper method to check if user is authenticated
  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;
}
