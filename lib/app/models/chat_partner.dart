class Partner {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? status;
  final String? avatar;
  Partner({
    required this.id,
    required this.username,
    required this.status,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      status: json['status'],
      avatar: json['avatar'],
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
