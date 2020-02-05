import 'dart:io';
import 'package:device_info/device_info.dart';

class DeviceInfoHelper{

  static String getDeviceId(){
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
    return id;
  }
}     
    
