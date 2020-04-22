import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHelper {
  static String hashPassword(String password) {
    var passwordBytes = utf8.encode(password);
    return sha512.convert(passwordBytes).toString();
  }
}
