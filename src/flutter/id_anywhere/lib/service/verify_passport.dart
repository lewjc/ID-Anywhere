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
import 'package:id_anywhere/models/passport_model.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/service_result.dart';
import 'package:id_anywhere/service/verification/levenshtein_algorithm.dart';
import 'package:id_anywhere/service/verification/upload_certainty.dart';
import 'package:id_anywhere/state/session.dart';

class VerifyPassportService {
  final RegExp findKeyLines = new RegExp(
    r".*\([1-9]\).*",
    caseSensitive: false,
    multiLine: false,
  );

  final List<UploadCertainty> validators = [
    UploadCertainty(
        desiredString: "Passport No./Passeport No.", levenshteinThreshold: 3),
    UploadCertainty(desiredString: "Surname/Nom (1)", levenshteinThreshold: 3),
    UploadCertainty(
        desiredString: "Given names/Prénoms (2)", levenshteinThreshold: 3),
    UploadCertainty(
        desiredString: "Date of birth/Date de naissance (4)",
        levenshteinThreshold: 3),
    UploadCertainty(
        desiredString: "Date of expiry/Date d'expiration (9)",
        levenshteinThreshold: 3),
  ];

  Future<ServiceResult> verify(File image) async {
    /**
     * 
     * So, for this we need to create a threshold of certainty for the initial 
     * Upload. By having a class that is called an UploadCertainty Object. We can 
     * If the block contains the 
     * 
     */

    final result = new ServiceResult();
    TextRecognizer textRecognizer;
    try {
       textRecognizer = FirebaseVision.instance.textRecognizer();
      bool passportNumberExtracted = false;
      final FirebaseVisionImage firebaseImage =
          FirebaseVisionImage.fromFile(image);
      final text = await textRecognizer.processImage(firebaseImage);
      String mrz = this.extractMRZ(text);
      // If mrz length is 88.

      for (int i = 0; i < text.blocks.length; i++) {
        TextBlock block = text.blocks[i];
        for (int j = 0; j < block.lines.length; j++) {
          TextLine line = block.lines[j];
          if (line.text.contains(findKeyLines)) {
            // We have found a line that we need to extract information from.
            String currentText = block.lines[j].text;
            List<bool> thresholds = await testThresholds(currentText);
            int indexOfMatch = thresholds.indexOf(true);
            if (indexOfMatch != -1) {
              final uploadCertainty = this.validators[indexOfMatch + 1];
              uploadCertainty.resultText = (j == block.lines.length - 1
                      ? text.blocks[i + 1].lines[0]
                      : block.lines[j + 1])
                  .text;
            }
          } else if (!passportNumberExtracted) {
            passportNumberExtracted =
                await checkForPassportNumber(block.lines[j].text);
            if (passportNumberExtracted) {
              // The next line will be the number, however may also be the first line
              // of the next block.
              this.validators[0].resultText = (j == block.lines.length - 1
                      ? text.blocks[i + 1].lines[0]
                      : block.lines[j + 1])
                  .text;
            }
          }
        }
      }

      // Run all of the validators.
      return await this.finaliseValidation(mrz, image);
    } catch (e) {
      print(e);
      result.errors.add(
          "Not all information could be extracted. Please provide a clearer image of your passport.");
      return result;      
    } finally {
      textRecognizer?.close();
    }
  }

  Future<bool> checkForPassportNumber(String text) async {
    return await LevenshteinAlgorithm.run(
        validators[0].desiredString, text, validators[0].levenshteinThreshold);
  }

  int getLineIndex(length, i) {
    return (i == length - 1 || i == 0 ? i : i + 1);
  }

  Iterable<Future<bool>> generateCertaintyMethods(start, end, text) {
    return Iterable.generate(start - end, (int x) {
      return LevenshteinAlgorithm.run(validators[start + x].desiredString, text,
          validators[start + x].levenshteinThreshold);
    });
  }

  Future<List<bool>> testThresholds(String text) async {    
    return await Future.wait([
      LevenshteinAlgorithm.run(validators[1].desiredString, text,
          validators[1].levenshteinThreshold),
      LevenshteinAlgorithm.run(validators[2].desiredString, text,
          validators[2].levenshteinThreshold),
      LevenshteinAlgorithm.run(validators[3].desiredString, text,
          validators[3].levenshteinThreshold),
      LevenshteinAlgorithm.run(validators[4].desiredString, text,
          validators[4].levenshteinThreshold),
    ]);
  }

  String extractMRZ(VisionText text) {
    String mrz = "";
    if (text.blocks.last.lines.length > 1) {
      // If the ocr has reconised the mrz as two lines in a block as opposed to
      // 2 different blocks.
      for (int i = 0; i < text.blocks.last.lines.length; i++) {
        String currentText =
            text.blocks.last.lines[i].text.trim().replaceAll(" ", "");
        if (currentText.length == 44) {
          mrz += currentText;
        }
      }
    } else {
      mrz = (text.blocks[(text.blocks.length - 2)].text +
              text.blocks[(text.blocks.length - 1)].text)
          .replaceAll(" ", "");
    }

    return mrz;
  }

  Future<ServiceResult> finaliseValidation(String mrz, File image) async {
    // Go through each certainty result and create our model to upload.
    // IF any of these fail, we cannot create the model
    final number = this.validatePassportNumber(this.validators[0].resultText);
    final surname = this.validators[1].resultText;
    final firstname = extractFirstName(this.validators[2].resultText);
    final dateOfBirth = validateDateOfBirth(this.validators[3].resultText);
    final expiry = validateExpiry(this.validators[4].resultText);

    if(dateOfBirth == null){
      // get input for this
    }

    if(expiry == null){
      // get input for this.
    }

    mrz = mrz.length == 88 ? mrz : null;

    final model = PassportModel(
        firstname: firstname,
        lastname: surname,
        number: number,
        dateOfBirth: dateOfBirth,
        expiry: expiry,
        mrz: mrz);

    if (model.isValid()) {
      // Here we need to upload the photo file as well as post the data to the api.
      final result = await this.postModel(model, image);
      return result;
    }

    return new ServiceResult(errors: [
      "Some parts of the image were not valid. Please reupload a clearer picture"
    ]);
  }

  Future<ServiceResult> postModel(PassportModel model, File image) async {
    ServiceResult result = new ServiceResult();
    String url = GlobalConfiguration().getString("api_url");
    url = "$url/api/upload/passport";
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
          cloudStorage.child("passport").putFile(image);

      uploadTask.onComplete.then((complete) async {   
        await resolver<FlutterSecureStorage>()
            .write(key: Flags.passportUploaded, value: "true");
      });
      return result;
    } else if (response.statusCode == 401) {
      // Unauthorised, token may have expired, get user to login and try again.
      result.unauthorised = true;
    } else if (response.statusCode == 400) {
      // bad request, some parts of the model were not valid.
      // Get errors from response and put in the service result
    } else {
      // Unknown internal server error occured.
    }

    return result;
  }

  void uploadImage(File image) {}

  String extractFirstName(String text) {
    return text?.split(" ")[0];
  }

  String validatePassportNumber(String text) {
    return text?.length == 9 ? text : null;
  }

  DateTime validateExpiry(String text) {
    // Extract and turn into date
    try{
      List<String> split = text.split(" ");

      int day = int.tryParse(split[0]);
      int month = DateHelper.parseMonth(split[1]);

      for (int i = 2; i < split.length; i++) {
        var parseable = int.tryParse(split[i]);
        if (parseable != null) {
          int year = int.tryParse("20" + split[i]);

          DateTime expiry = DateTime(year, month, day);
          if (expiry.isBefore(DateTime.now())) {
            // The passport submitted was expired. show this.
            return null;
          }
          return expiry;
        }
      }
    } on Exception {
      return null;
    }
    return null;
  }

  DateTime validateDateOfBirth(String text) {
    // extract and turn into date.
    List<String> dobSplit = text.split(" ");
    var day = int.tryParse(dobSplit[0]);
    int month = DateHelper.parseMonth(dobSplit[1]);
    
    if(month == 0){
      month = DateHelper.parseMonth(dobSplit[1].substring(0, 3));
      if(month == 0){
        return null;
      }
    }

    for (int i = 2; i < dobSplit.length; i++) {
      var parseable = int.tryParse(dobSplit[i]);
      if (parseable != null) {
        // Working out whether it will be a 1900 or 2000 birthday.
        String yearPrefix = "20";
        if (DateTime.now().year - 2000 < parseable) {
          yearPrefix = "19";
        }
        int year = int.tryParse("$yearPrefix$parseable");
        return DateTime(year, month, day).add(Duration(hours: 6));
      }
    }

    return null;
  }
}
