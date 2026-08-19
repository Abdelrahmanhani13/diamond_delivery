import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? genderId;
  final String? dateOfBirth;
  final String membershipBadge;
  final int completedOrdersCount;
  final double userRating;
  final double walletBalance;

  const ProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.genderId,
    this.dateOfBirth,
    this.membershipBadge = 'عضو ذهبي مميز',
    this.completedOrdersCount = 0,
    this.userRating = 5.0,
    this.walletBalance = 0.0,
  });

  ProfileEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? genderId,
    String? dateOfBirth,
    String? membershipBadge,
    int? completedOrdersCount,
    double? userRating,
    double? walletBalance,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      genderId: genderId ?? this.genderId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      membershipBadge: membershipBadge ?? this.membershipBadge,
      completedOrdersCount: completedOrdersCount ?? this.completedOrdersCount,
      userRating: userRating ?? this.userRating,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        genderId,
        dateOfBirth,
        membershipBadge,
        completedOrdersCount,
        userRating,
        walletBalance,
      ];
}
