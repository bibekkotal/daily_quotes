import 'dart:io';

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

class NetworkCheckerUtils {
  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
