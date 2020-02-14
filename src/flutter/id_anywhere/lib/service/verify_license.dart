import 'dart:developer';
import 'dart:io';

import 'package:id_anywhere/service/service_result.dart';

class VerifyLicenseService{

  Future<ServiceResult> verifyFront(File image) async{
    // This should scan the license image, 
    // then extract appropriate information, to validate this is a license.
    ServiceResult result = new ServiceResult();
    return result;
  }

  Future<ServiceResult> verifyBack(File image) async{
    // This should scan the license image, 
    // then extract appropriate information, to validate this is a license.
    ServiceResult result = new ServiceResult();
    return result;
  }
}