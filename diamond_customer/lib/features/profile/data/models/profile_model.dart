import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    super.genderId,
    super.dateOfBirth,
    super.membershipBadge,
    super.completedOrdersCount,
    super.userRating,
    super.walletBalance,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['userId'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      genderId: json['genderId'],
      dateOfBirth: json['dateOfBirth'],
      membershipBadge:
          json['membershipBadge'] as String? ?? 'عضو ذهبي مميز',
      completedOrdersCount:
          (json['completedOrdersCount'] as num?)?.toInt() ?? 0,
      userRating: (json['userRating'] as num?)?.toDouble() ?? 5.0,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'genderId': genderId,
      'dateOfBirth': dateOfBirth,
      'membershipBadge': membershipBadge,
      'completedOrdersCount': completedOrdersCount,
      'userRating': userRating,
      'walletBalance': walletBalance,
    };
  }
}
