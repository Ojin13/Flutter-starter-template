class PasswordValidator {
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter.';
    }

    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }

    if (!RegExp(r'^(?=.*[0-9])').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }

    bool specialChar =
    (RegExp(r'''[$*.[\]{}()?\-''!@#%&/\\,><:;_~`+=]''')).hasMatch(value);

    if (!specialChar) {
      return 'Password must contain at least one special character.';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters.';
    }

    if (value.toLowerCase().contains('password')) {
      return "Password cannot contain the word 'password'.";
    }

    return null;
  }
}
