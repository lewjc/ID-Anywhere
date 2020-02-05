import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LocalAuthenticationService {
  
  LocalAuthenticationService({this.isProtectionEnabled=false});

  final _auth = LocalAuthentication();
  bool isProtectionEnabled;
  bool isAuthenticated = false;

  Future<bool> authenticate(String reason) async {
    if (isProtectionEnabled) {
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
