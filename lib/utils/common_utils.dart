import 'app_exports.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return StaticStrings.enterEmail;
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return StaticStrings.invalidEmail;
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return StaticStrings.enterPassword;
  }
  if (value.length < 6) {
    return StaticStrings.shortPassword;
  }
  if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$').hasMatch(value)) {
    return StaticStrings.weakPassword;
  }
  return null;
}
