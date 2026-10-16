class Validators {
  Validators._();
  /// Validates if a string is not empty.
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates email format using RegExp.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Validates a password to ensure it meets security requirements:
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required.';
    }

    final password = value.trim();

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Add at least 1 uppercase letter (A-Z).';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Add at least 1 lowercase letter (a-z).';
    }

    if (!RegExp(r'[!@#$&*~%^()\-_=+{}[\]|;:"<>,.?/]').hasMatch(password)) {
      return 'Add 1 special char (!@#\$% etc).';
    }

    if (password.length < 6) {
      return 'Minimum 6 characters.';
    }

    return null;
  }
}
