class SignupResponseModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  SignupResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
