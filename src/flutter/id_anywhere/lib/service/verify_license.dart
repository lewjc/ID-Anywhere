import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:id_anywhere/constants/flags.dart';
import 'package:id_anywhere/data/ida_firebase.dart';
import 'package:id_anywhere/helper/date_helper.dart';
import 'package:id_anywhere/helper/device_info.dart';
import 'package:id_anywhere/helper/http.dart';
import 'package:id_anywhere/models/license_model.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/service_result.dart';
import 'package:id_anywhere/state/session.dart';

class VerifyLicenseService {
  static final RegExp licenseNumberPattern = new RegExp(
    r"^[A-Z9]{5}\d{6}[A-Z9]{2}\d[A-Z]{2}$",
    caseSensitive: false,
    multiLine: false,
  );

  final Map<String, Function(int, int, VisionText, LicenseModel model)>
      desiredLineIndicators = {
    "1": extractLastName,
    "2": extractFirstName,
    "3": extractDateOfBirth,
    "4b": extractExpirationDate,
    "5": extractLicenseNumber,
  };

  Future<ServiceResult> verifyFront(File image) async {
    // This should scan the license image,
    // then extract appropriate information, t  o validate this is a license.
    ServiceResult result = new ServiceResult();
    LicenseModel model = new LicenseModel();
    try{
      final text = await this.getTextFromImage(image);
      for (int i = 0; i < text.blocks.length; i++) {
        TextBlock block = text.blocks[i];
        for (int j = 0; j < block.lines.length; j++) {
          TextLine line = block.lines[j];
          print(line.text);
          List<String> lineInfo = line.text.split(" ");
          String indicator = lineInfo[0].replaceAll(".", "");
          if (this.desiredLineIndicators.keys.contains(indicator)) {
            // The line indicator is one we are looking for, run the desired function assoicated with it.
            // We then store the string in the model.
            this.desiredLineIndicators[indicator](i, j, text, model);
          }
        }
      }
    } catch(e){    
      result.errors.add("Not all information could be extracted. Please provide a clearer image of your license.");
      return result;
    }
    if (model.isValid()) {
      return await this.postModel(model, image, "/api/upload/licensefront",
          "license_front", Flags.frontLicenseUploaded);
    } else {
      result.errors.add(
          "Not all information could be extracted. Please provide a clearer image of your license.");
    }
    return result;
  }

  Future<ServiceResult> verifyBack(File image) async {
    // This should scan the license image,
    // then extract appropriate information, to validate this is a license.
    ServiceResult result = new ServiceResult();
     
    StorageReference cloudStorage =
          await FirebaseConnection().getUserStorageReference();
    cloudStorage = cloudStorage
        .child(DeviceInfoHelper.hashId(await DeviceInfoHelper.getDeviceId()));
    final StorageUploadTask uploadTask =
        cloudStorage.child("license_back").putFile(image);

    uploadTask.onComplete.then((complete) async {
      await resolver<FlutterSecureStorage>()
          .write(key: Flags.backLicenseUploaded, value: "true");
    });

    String url = GlobalConfiguration().getString("api_url");
    url = "$url/api/upload/licenseback";
    Session session = resolver<Session>();
    final response = await HttpHelper.postJsonWithAuthorization(
       null, url, session.token);

    return result;
  }

  Future<VisionText> getTextFromImage(File image) async {
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    try {
      final FirebaseVisionImage firebaseImage =
          FirebaseVisionImage.fromFile(image);
      return await textRecognizer.processImage(firebaseImage);
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<ServiceResult> postModel(LicenseModel model, File image,
      String urlExtension, String pictureName, String flag) async {
    ServiceResult result = new ServiceResult();
    String url = GlobalConfiguration().getString("api_url");
    url = "$url$urlExtension";
    Session session = resolver<Session>();
    final response = await HttpHelper.postJsonWithAuthorization(
        model.toJson(), url, session.token);

    if (response.statusCode == 200) {
      // The upload for the passport worked.
      StorageReference cloudStorage =
          await FirebaseConnection().getUserStorageReference();
      cloudStorage = cloudStorage
          .child(DeviceInfoHelper.hashId(await DeviceInfoHelper.getDeviceId()));
      final StorageUploadTask uploadTask =
          cloudStorage.child(pictureName).putFile(image);

      uploadTask.onComplete.then((complete) async {
        await resolver<FlutterSecureStorage>()
            .write(key: flag, value: "true");
      });
      return result;
    } else if (response.statusCode == 401) {
      // Unauthorised, token may have expired, get user to login and try again.
      result.unauthorised = true;
    } else if (response.statusCode == 400) {
      // bad request, some parts of the model were not valid.
      // Get errors from response and put in the service resul
    } else {
      // Unknown internal server error occured.
    }

    return result;
  }

  static void extractFirstName(
      int currentBlock, int currentLine, VisionText text, LicenseModel model) {
    model.firstname =
        text.blocks[currentBlock].lines[currentLine].text.split(" ")[2];
  }

  static void extractLastName(
      int currentBlock, int currentLine, VisionText text, LicenseModel model) {
    try {
      model.lastname =
          text.blocks[currentBlock].lines[currentLine].text.split(" ")[1];
    } on IndexError catch (e) {
      print(e);
      return null;
    }
  }

  static void extractLicenseNumber(
      int currentBlock, int currentLine, VisionText text, LicenseModel model) {
    // Here we have to search around the next block for something that matches the license number pattern.
    for (int i = currentBlock; i < text.blocks.length; i++) {
      TextBlock block = text.blocks[i];
      for (int j = currentLine; j < block.lines.length; j++) {
        String lineText = block.lines[j].text;
        lineText = lineText.replaceAll(" ", "");
        if (lineText.length == 18) {
          lineText = lineText.substring(0, 16);
          if (licenseNumberPattern.hasMatch(lineText)) {
            // May need to split here.
            model.number = lineText;
          }
        }
      }
      currentLine = 0;
    }
    return null;
  }

  static void extractExpirationDate(
      int currentBlock, int currentLine, VisionText text, LicenseModel model) {
    model.expiry = DateHelper.parseLicenseDate(
        text.blocks[currentBlock].lines[currentLine].text.split(" ")[1]);
  }

  static void extractDateOfBirth(
      int currentBlock, int currentLine, VisionText text, LicenseModel model) {
    model.dateOfBirth = DateHelper.parseLicenseDate(
        text.blocks[currentBlock].lines[currentLine].text.split(" ")[1]).add(Duration(hours: 6));
  }
}
