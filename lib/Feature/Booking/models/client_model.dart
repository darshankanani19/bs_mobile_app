class ClientModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  String get fullName => "$firstName $lastName";
}
