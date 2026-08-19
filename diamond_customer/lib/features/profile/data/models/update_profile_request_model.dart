class UpdateProfileRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? genderId;
  final String? dateOfBirth;

  const UpdateProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.genderId,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      if (genderId != null) 'genderId': genderId,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    };
  }
}
