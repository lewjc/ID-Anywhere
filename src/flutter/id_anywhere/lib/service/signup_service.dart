import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:id_anywhere/data/ida_firebase.dart';
import 'package:id_anywhere/models/signup_model.dart';

class SignupService {
  Future<bool> executeSignup(
      String firstName, String lastName, String email, String password) async {
    if (!await validateEmail(email)) {
      return false;
    }
    // Hash password so it is not in plain text.
    var passwordBytes = utf8.encode(password);
    var passwordHash = sha512.convert(passwordBytes);

    // So now, we will need to post to the csharp api, to create a new user.
    // We will also use the app ID to store firebase email and passsword, this
    // is then grabbed when biometrics is used and posted to the api.

    SignupModel model = SignupModel(
        firstname: firstName,
        lastname: lastName,
        email: email,
        password: passwordHash.toString());

    return await this._create(model);
  }

  Future<bool> _create(SignupModel model) async {
    String url = GlobalConfiguration().getString("api_url");
    var response;
    try{
      response = await http.post(
        "$url/api/account/register",
        body: jsonEncode(model.toJson()),
        headers: {"Content-type": "application/json"},
        encoding: Encoding.getByName("utf-8")
        );

    } on Exception catch(e){
      print('Error caught, $e');
      
    }
    
    if (response.statusCode == 200) {
      String id;

      if (Platform.isAndroid) {
        DeviceInfoPlugin().androidInfo.then((build) {
          id = build.androidId;
        });
      } else {
        DeviceInfoPlugin().iosInfo.then((build) {
          id = build.identifierForVendor;
        });
      }

      FirebaseConnection().getUserInfoReference().child(id).set({
        'email': model.email,
        'password': model.password
      });
      
      return true;
    }

    return false;
  }

  Future<bool> validateEmail(String email) async {
    // Here we will hit the api endpoint which will
    // check and see if the email exists or not
    return true;
  }
}
