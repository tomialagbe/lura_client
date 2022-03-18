class SignupFailedException implements Exception {
  final String message;

  const SignupFailedException([this.message = 'An unknown error occurred']);

  factory SignupFailedException.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const SignupFailedException(
            'This email address is already in use');
      case 'invalid-email':
        return const SignupFailedException('Invalid email address');
      default:
        return const SignupFailedException();
    }
  }
}

class LoginFailedException implements Exception {
  final String message;

  const LoginFailedException([this.message = 'An unknown error occurred']);

  factory LoginFailedException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
      case 'wrong-password':
        return const LoginFailedException(
            'Invalid email or password. Please try again');
      case 'user-disabled':
        return const LoginFailedException(
            'This user has been disabled. Please contact support for help');
      case 'user-not-found':
        return const LoginFailedException(
            'User not found. Please create an account');
      case 'custom-token-mismatch':
        return const LoginFailedException(
            'Login failed. This token is from a different app');
      case 'invalid-custom-token':
        return const LoginFailedException(
            'Login failed. Invalid custom token.');
      default:
        return const LoginFailedException();
    }
  }
}
