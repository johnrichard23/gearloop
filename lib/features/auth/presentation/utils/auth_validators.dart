/// Field validators shared by the log in, sign up and reset password screens.
abstract final class AuthValidators {
  static final RegExp _emailRegex = RegExp(
    r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$',
  );

  /// Fails when [value] is null or only whitespace.
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Fails when [value] is empty or not shaped like an email address.
  static String? email(String? value) {
    final emptyError = required(value);
    if (emptyError != null) {
      return emptyError;
    }
    if (!_emailRegex.hasMatch(value!.trim())) {
      // non-null: required() passed
      return 'Enter a valid email address';
    }
    return null;
  }
}
