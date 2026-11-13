class UserModel {
  final String id;
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
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['full_name'] ?? json['name'] ?? json['username'] ?? '',
      role: json['role'] ?? 'grower',
      phone: json['phone'],
      location: json['location'],
      businessName: json['business_name'],
      avatarUrl: json['avatar_url'],
      token: json['access_token'] ?? json['token'],
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
