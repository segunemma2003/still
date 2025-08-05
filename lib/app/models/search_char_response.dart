class SearchUser {
  final String? avatar;
  final int id;
  final String username;
  final String? phone;
  final String? firstName;
  final String? lastName;

  SearchUser(
      {required this.id,
      required this.username,
      required this.phone,
      required this.firstName,
      required this.lastName,
      this.avatar});

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      id: json['id'] as int,
      username: json['username'] as String,
      phone: json['phone'] != null ? json['phone'] as String : null,
      firstName: json['firstName'] != null ? json['firstName'] as String : null,
      lastName: json['lastName'] != null ? json['lastName'] as String : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

// List<SearchUser> searchUserListFromJson(List<dynamic> json) =>
//     json.map((e) => SearchUser.fromJson(e as Map<String, dynamic>)).toList();

// List<dynamic> searchUserListToJson(List<SearchUser> users) =>
//     users.map((e) => e.toJson()).toList();
