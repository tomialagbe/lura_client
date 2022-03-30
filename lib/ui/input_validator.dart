abstract class InputValidator {
  static String? _password;

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Your email is required';
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Your password is required';
    }

    if (password.length < 6) {
      return 'Your password must be at least 6 characters long';
    }

    _password = password;

    return null;
  }

  static String? validateConfirmPassword(String? passwordConfirm) {
    if (passwordConfirm == null || passwordConfirm.trim().isEmpty) {
      return 'Your password is required';
    }

    if (passwordConfirm.length < 6 || passwordConfirm != _password) {
      return 'The two passwords must match';
    }

    _password = null;
    return null;
  }
}
