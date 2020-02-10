import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:id_anywhere/constants/flags.dart';
import 'package:id_anywhere/data/ida_firebase.dart';
import 'package:id_anywhere/helper/device_info.dart';
import 'package:id_anywhere/helper/http.dart';
import 'package:id_anywhere/models/login_model.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/service_result.dart';

class LoginService {
  Future<ServiceResult> executeLogin(String email, String password) async {
    var appId = DeviceInfoHelper.hashId(await DeviceInfoHelper.getDeviceId());
    LoginModel model = LoginModel(email: email, password: password, appID: appId);
    if (model.isValid()) {
      String url = GlobalConfiguration().getString("api_url");
      url = "$url/api/account/login";
      try{
        Response response = await HttpHelper.postJson(model.toJson(), url);
        return handleResponse(response);
      } on Exception catch(e){
        print(e);
      }      
    }
    
    return ServiceResult(errors: ["Invalid email or password"]);
  }

  Future<ServiceResult> handleResponse(Response response) async{
    ServiceResult result = ServiceResult();
    if(response.statusCode == 200){
      // Login successful, store JWT and then login to home.
      var responseData = json.decode(response.body);
      String token = responseData["token"];
      // Return a token, firstname and status. This can be stored in the current user's session.
      resolver<FlutterSecureStorage>().write(key: Flags.jwt, value: token);
      return result;
    } else{
      // Invalid username or password
      result.errors = json.decode(response.body)["errors"];
      return result;
    }
  }

  Future<ServiceResult> loginFromLocalAuth() async{
    final connection = resolver<FirebaseConnection>();
    final idHash = DeviceInfoHelper.hashId(await DeviceInfoHelper.getDeviceId());
    DocumentSnapshot document = await (await connection.getUserInfoReference()).document(idHash).get();    
    String email = document.data["email"];
    String password = document.data["password"];
    return await executeLogin(email, password);
  }
}
