class ValidationHelper {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().length < 10) return 'Enter a valid phone number';
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value != password) return 'Passwords do not match';
    return null;
  }
}
