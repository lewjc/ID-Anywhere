import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpHelper {
  static Future<Response> postJson(
      Map<String, dynamic> json, String url) async {
    return await http.post(url,
        body: jsonEncode(json),
        headers: {"Content-type": "application/json"},
        encoding: Encoding.getByName("utf-8"));
  }

  static Future<Response> postJsonWithAuthorization(
      Map<String, dynamic> json, String url, String token) async {
    return await http.post(url,
        body: jsonEncode(json),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        encoding: Encoding.getByName("utf-8"));
  }
}
