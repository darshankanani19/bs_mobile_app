class ApiEndPoints {
  static const String baseUrl = 'https://bsadmin.namasteaylesbury.com/api';

  static const String signup = '$baseUrl/auth/register/';
  static const String login = '$baseUrl/auth/login/';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String getuser = '$baseUrl/users/profile';
  static const String productList = '$baseUrl/products/';
  static const String subProductList = '$baseUrl/sub_products/';
  static const String address = '$baseUrl/addresses/';
  static const String getbooking =
      'https://44981rhl-8001.inc1.devtunnels.ms/bookings/list';
  static final String Booking =
      'https://44981rhl-8001.inc1.devtunnels.ms/bookings';

  static const String placeorder = '$baseUrl/orders/';
  static const String logout = '$baseUrl/auth/logout';
  static const String orderhistory = '$baseUrl/orders/history';
}
