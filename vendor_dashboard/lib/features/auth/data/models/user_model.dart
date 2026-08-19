import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.roles = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] ?? '',
      name: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phoneNumber'] ?? '',
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'fullName': name,
      'email': email,
      'phoneNumber': phone,
      'roles': roles,
    };
  }
}
