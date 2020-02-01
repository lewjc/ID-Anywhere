import 'dart:convert'; 
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

class SignupService {
  Future<bool> executeSignup(
      String firstName, String lastName, String email, String password) async {
    // Hash password so it is not in plain text.
    var passwordBytes = utf8.encode(password);
    var passwordHash = sha512.convert(passwordBytes);

    // So now, we will need to post to the csharp api, to create a new user.
    // We will also use the app ID to store firebase email and passsword, this
    // is then grabbed when biometrics is used and posted to the api.
    String url = GlobalConfiguration().getString("api_url");
    var response = await http.post(
    "https://lewiscummins.dev:8000/api/upload/Passport",
      body: jsonEncode(payload),
      headers: {
        "Content-type": "application/json"
      },
      encoding: Encoding.getByName("utf-8")
    );


    return true;
  }

  bool validateEmail(String email){
    // Here we will hit the api endpoint which will 
    // check and see if the email exists or not
  }
}
