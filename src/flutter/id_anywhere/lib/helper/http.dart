import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  static postJson(Map<String, dynamic> json, String url) async {
    return await http.post(url,
        body: jsonEncode(json),
        headers: {"Content-type": "application/json"},
        encoding: Encoding.getByName("utf-8"));
  }
}
