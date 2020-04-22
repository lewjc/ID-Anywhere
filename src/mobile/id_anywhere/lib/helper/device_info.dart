import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';

class DeviceInfoHelper {
  static Future<String> getDeviceId() async{
    String id;
    if (Platform.isAndroid) {
      id = (await DeviceInfoPlugin().androidInfo).androidId;
    } else {
      id = (await DeviceInfoPlugin().iosInfo).identifierForVendor;
    }
    return id;
  }

  static String hashId(String id) {
    return sha256.convert(utf8.encode(id)).toString();
  }
}
