class ApiEndPoints {
  static const String baseUrlAuth = 'https://bsadmin.namasteaylesbury.com/api';
  static const String baseUrl = 'https://bsapis.namasteaylesbury.com';

  static const String signup = '$baseUrlAuth/auth/register/';
  static const String login = '$baseUrlAuth/auth/login/';
  static const String forgotPassword = '$baseUrlAuth/auth/forgot-password';
  static const String resetPassword = '$baseUrlAuth/auth/reset-password';
  static const String refreshToken = '$baseUrlAuth/auth/refresh';
  static const String appointment = '$baseUrl/appointment';
  static final String appointments = '$baseUrl/appointments/';
  static String appointmentById(int id) => '$baseUrl/appointments/$id';
  static const String logout = '$baseUrlAuth/auth/logout';
}
