import 'package:id_anywhere/constants/flags.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthenticationService {
  
  LocalAuthenticationService();

  final _auth = LocalAuthentication();
  Future<bool> isProtectionEnabled () async =>  
    (await SharedPreferences.getInstance()).getBool(Flags.useLocalAuth) ?? true;

  bool isAuthenticated = false;

  Future<bool> authenticate(String reason) async {
    if (await isProtectionEnabled()) {
      try {
        return await _auth.authenticateWithBiometrics(
          localizedReason: reason,
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        print(e);        
      }
    }
    
    return false;
  }
}
  