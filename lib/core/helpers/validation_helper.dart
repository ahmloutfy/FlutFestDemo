class ValidationHelper {
  /// Validates that the field is not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password strength (min 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Validates that two passwords match
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates full name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full Name is required';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name (at least two names)';
    }
    return null;
  }
}
