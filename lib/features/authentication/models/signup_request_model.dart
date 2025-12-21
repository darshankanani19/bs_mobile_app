class SignUpRequestModel {
  final String firstName;
  final String lastName;
  final String userType;
  final String email;
  final String password;

  SignUpRequestModel({
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "user_type": userType,
      "email": email,
      "password": password,
    };
  }
}
