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
    final rawName = json['fullName'] ?? json['name'] ?? '';
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    final constructedName = (firstName.toString().isNotEmpty || lastName.toString().isNotEmpty)
        ? '$firstName $lastName'.trim()
        : rawName.toString();

    return UserModel(
      id: (json['userId'] ?? json['id'] ?? '').toString(),
      name: constructedName,
      email: (json['email'] ?? json['emailAddress'] ?? '').toString(),
      phone: (json['phoneNumber'] ?? json['phone'] ?? json['mobileNumber'] ?? '').toString(),
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
