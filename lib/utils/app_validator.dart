class AppValidator {
  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Provide an email please';
    }
    RegExp emailExp = RegExp(
        r'^[\w\-\.\+]+@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$');
    if (!emailExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    RegExp passwordExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!passwordExp.hasMatch(value)) {
      return 'Password must contain at least 8 characters, including one uppercase letter, one lowercase letter, one digit, and one special character.';
    }
    return null;
  }
}
