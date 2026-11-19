class UserModel {
  final dynamic id;
  final String email;
  final String name;
  final String role; // 'grower' or 'vendor'
  final String? phone;
  final String? location;
  final String? businessName;
  final String? avatarUrl;
  final String? token;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'grower',
    this.phone,
    this.location,
    this.businessName,
    this.avatarUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = (json['user'] is Map<String, dynamic>)
        ? json['user'] as Map<String, dynamic>
        : json;

    return UserModel(
      id: userData['id'] ??
          userData['user_id'] ??
          userData['_id'] ??
          DateTime.now().millisecondsSinceEpoch,
      email: userData['email'] ?? '',
      name: userData['full_name'] ??
          userData['name'] ??
          userData['username'] ??
          (userData['email'] != null
              ? (userData['email'] as String).split('@').first
              : 'User'),
      role: userData['role'] ?? json['role'] ?? 'grower',
      phone: userData['phone'] ?? userData['phone_number'],
      location: userData['location'],
      businessName: userData['business_name'] ?? userData['company_name'],
      avatarUrl: userData['avatar_url'] ?? userData['profile_picture'],
      token: json['access_token'] ??
          json['token'] ??
          userData['access_token'] ??
          userData['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': name,
      'role': role,
      if (phone != null) 'phone': phone,
      if (location != null) 'location': location,
      if (businessName != null) 'business_name': businessName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (token != null) 'access_token': token,
    };
  }
}
