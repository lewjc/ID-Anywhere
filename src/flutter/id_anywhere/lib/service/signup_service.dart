import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:id_anywhere/helper/http.dart';
import 'package:id_anywhere/helper/password.dart';
import 'package:id_anywhere/models/signup_model.dart';
import 'package:id_anywhere/service/service_result.dart';

class SignupService {
  Future<ServiceResult> executeSignup(String firstName, String lastName, String email,
      String password) async {
    if (!await validateEmail(email)) {
      return ServiceResult(errors: ["Email already exists"]);
    }
  
    SignupModel model = SignupModel(
        firstname: firstName,
        lastname: lastName,
        email: email,
        password: PasswordHelper.hashPassword(password));

    return await this._create(model);
  }

  Future<ServiceResult> _create(SignupModel model) async {
    Response response;
    ServiceResult result = ServiceResult();
    String url = GlobalConfiguration().getString("api_url");
    url = "$url/api/account/signup";

    try {
      response = await HttpHelper.postJson(model.toJson(), url);
    } on Exception catch (e) {
      print('Error caught, $e');
    }
    
    if (response.statusCode == 200) {
      return result;
    } else if (response.statusCode == 400) {
      var body = json.decode(response.body);
      result.errors = body['errors'];
      return result;
    }
    result.errors.add("An error has occured");
    return result;
  }

  Future<bool> validateEmail(String email) async {
    // Here we will hit the api endpoint which will
    // check and see if the email exists or not
    return true;
  }
}
