import 'package:nylo_framework/nylo_framework.dart';

class UserInfo extends Model {
  static StorageKey key = "user_info";

  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? avatar;
  bool? isOnline;
  bool? isVerified;

  UserInfo({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatar,
    this.isOnline,
    this.isVerified,
  }) : super(key: key);

  UserInfo.fromJson(dynamic data) : super(key: key) {
    id = data['id'];
    username = data['username'];
    email = data['email'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    phone = data['phone'];
    avatar = data['avatar'];
    isOnline = data['isOnline'];
    isVerified = data['isVerified'];
  }

  @override
  toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'avatar': avatar,
      'isOnline': isOnline,
      'isVerified': isVerified,
    };
  }

  // Helper methods
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else if (username != null) {
      return username!;
    } else {
      return 'Unknown User';
    }
  }

  String get searchText {
    List<String> searchableTexts = [];
    if (username != null) searchableTexts.add(username!);
    if (email != null) searchableTexts.add(email!);
    if (firstName != null) searchableTexts.add(firstName!);
    if (lastName != null) searchableTexts.add(lastName!);
    if (phone != null) searchableTexts.add(phone!);
    return searchableTexts.join(' ').toLowerCase();
  }
}
