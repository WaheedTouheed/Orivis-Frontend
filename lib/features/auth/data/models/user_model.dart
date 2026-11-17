class UserModel {
  final int id;
  final String email;
  final String name;
  final String? token;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? json['username'] ?? '',
      token: json['access_token'] ?? json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (token != null) 'access_token': token,
    };
  }
}
