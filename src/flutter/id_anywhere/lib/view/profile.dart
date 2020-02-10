import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:id_anywhere/constants/flags.dart';
import 'package:id_anywhere/data/ida_firebase.dart';
import 'package:id_anywhere/enum/verification_status.dart';
import 'package:id_anywhere/helper/device_info.dart';
import 'package:id_anywhere/helper/media_helper.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() {
    // Here we can check to see if the user has uploaded an image or not.
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  bool imageSet = false;
  String _verificationStatus;
  bool _uploading = false;
  bool _downloading = false;
  double _progess = 0;
  Image _profilePicture;
  // If the user does not have an image, then set up  load Icon

  void getImage() async {
    if (imageSet == true) {
      return;
    }
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            title: Text(
              "Profile Picture Standards:",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 5),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            ("The picture you upload must adhere to these rules. " +
                                "This picture will be checked and used when verifying you through your documents. "),
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Text(
                      "-",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    title: Text(
                      "Has a plain white background",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      "-",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    title: Text(
                      "You are looking straight at the camera",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      "-",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    title: Text(
                      "No hats, glasses, masks etc.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: SimpleDialogOption(
                            onPressed: () => Navigator.pop(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Okay",
                                  style:
                                      TextStyle(color: Colors.lightGreenAccent),
                                ),
                                Icon(Icons.check,
                                    color: Colors.lightGreenAccent),
                              ],
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        });

    MediaOption mediaOption = await MediaHelper.getUserMediaChoice(context);
    if (mediaOption != null) {
      var image = await ImagePicker.pickImage(
          imageQuality: 100,
          source: mediaOption == MediaOption.CAMERA
              ? ImageSource.camera
              : ImageSource.gallery);

      StorageReference cloudStorage =
          await FirebaseConnection().getUserStorageReference();
      cloudStorage = cloudStorage
          .child(DeviceInfoHelper.hashId(await DeviceInfoHelper.getDeviceId()));
      final StorageUploadTask uploadTask =
          cloudStorage.child("profile_picture").putFile(image);
      uploadTask.events.listen((event) {
        setState(() {
          this._uploading = true;
          this._progess = event.snapshot.bytesTransferred.toDouble() /
              event.snapshot.totalByteCount.toDouble();
        });
      }).onError((handleError) {
        setState(() {
          this._uploading = false;
          this.imageSet = false;
          this._profilePicture = null;
        });
      });

      uploadTask.onComplete.then((complete) async {
        setState(() {
          this._uploading = false;
          this.imageSet = true;
        });
        await resolver<FlutterSecureStorage>()
            .write(key: Flags.photoUploaded, value: "true");
      });
      this._profilePicture = Image.file(image);
    }
  }

  @override
  void initState() {
    final secureStorage = resolver<FlutterSecureStorage>();
    secureStorage.read(key: Flags.photoUploaded).then((flag) async {
      secureStorage.read(key: Flags.verificationStatus).then((status) {
        setState(() {
          this._verificationStatus = status ?? VerificationStatus.UNVERIFIED;
        });
      });
      if ((flag ?? 'false').toLowerCase() == 'true' &&
          this._profilePicture == null) {
        setState(() {
          this._downloading = true;
        });
        downloadProfilePicture().then((pic) {
          setState(() {
            this._profilePicture = pic;
            this.imageSet = (flag ?? 'false').toLowerCase() == 'true';
          });
        });
      }
    });
    super.initState();
  }

  Future<Image> downloadProfilePicture() async {
    var reference =
        await resolver<FirebaseConnection>().getUserStorageReference();
    String downloadUrl = await reference
        .child(DeviceInfoHelper.hashId(await DeviceInfoHelper.getDeviceId()))
        .child("profile_picture")
        .getDownloadURL();
    return Image.network(downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 40),
        uploadImageDetails(),
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: <Widget>[
                SizedBox(height: 59),
                Text(
                  "Welcome back, Lewis.",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Verification Status: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "${this._verificationStatus}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: getStatusColor()),
                    ),
                  ],
                ),
                checkUpload(),
                SizedBox(height: 20),
              ],
            )),
        Container(
          color: Colors.white,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 328.5),
            painter: CurvePainter(),
          ),
        ),
      ],
    );
  }

  Widget checkUpload() {
    if (this._uploading) {
      // Do progress bar
      Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: LinearProgressIndicator(
          value: this._progess,
          backgroundColor: Colors.black,
        ),
      );
    }

    return Spacer();
  }

  Material uploadImageDetails() => Material(
      color: Colors.white,      
      child: Ink(        
        decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent, width: 3.0),
            color: Colors.white,
            shape: BoxShape.circle,            
            image: this.imageSet
                ? DecorationImage(
                    image: this._profilePicture.image, fit: BoxFit.cover)
                : null),
        child: InkWell(
          //This keeps the splash effect within the circle
          borderRadius: BorderRadius.circular(
              1000.0), //Something large to ensure a circle
          onTap: this.imageSet ? null : getImage,
          splashColor: Colors.pink[100],
          child: Padding(
              padding: EdgeInsets.all(this.imageSet ? 100.0 : 75.0),
              child: this.imageSet
                  ? null
                  : this._downloading
                      ? null
                      : Column(children: [
                          Icon(
                            Icons.cloud_upload,
                            size: 25.0,
                            color: Colors.black,
                          ),
                          SizedBox(height: 10),
                          Text("Upload Profile Picture")
                        ])),
        ),
      ));

  Color getStatusColor() {
    return (this._verificationStatus == VerificationStatus.VERIFIED
        ? Colors.green
        : this._verificationStatus == VerificationStatus.PENDING
            ? Colors.orange
            : Colors.red);
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.pink;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
