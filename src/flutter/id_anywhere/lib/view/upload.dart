import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:id_anywhere/constants/flags.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/verify_license.dart';
import 'package:id_anywhere/service/verify_passport.dart';
import 'package:id_anywhere/widgets/ida_upload_card.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool passportUploaded;
  bool frontOfLicenseUploaded;
  bool backOfLicenseUploaded;

  @override
  void initState() {
    final storage = resolver<FlutterSecureStorage>();    
    Future.wait([
      storage.read(key: Flags.passportUploaded),
      storage.read(key: Flags.backLicenseUploaded),
      storage.read(key: Flags.frontLicenseUploaded)
    ]).then((values) {
      this.setState(() {
        this.passportUploaded =  values[0] != null && values[0].isNotEmpty;
        this.backOfLicenseUploaded = values[1] != null && values[1].isNotEmpty;
        this.frontOfLicenseUploaded =  values[2] != null && values[2].isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Here we need to do a lot of work.
    final licenseService = resolver<VerifyLicenseService>();
    final passportService = resolver<VerifyPassportService>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30),
        new IDAnywhereUploadCard(
          title: 'Driving License Front',
          validateImageCallback: licenseService.verifyFront,
          informationDialog: license(true),
          flag: Flags.frontLicenseUploaded,
          complete: this.frontOfLicenseUploaded,
        ),
        new IDAnywhereUploadCard(
          title: 'Driving License Back',
          validateImageCallback: licenseService.verifyFront,
          informationDialog: license(false),
          flag: Flags.backLicenseUploaded,
          complete: this.backOfLicenseUploaded,
        ),
        new IDAnywhereUploadCard(
          title: 'Passport',
          validateImageCallback: passportService.verify,
          flag: Flags.passportUploaded,
          complete: this.passportUploaded
        ),
        Container(
          color: Colors.white,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 296.2),
            painter: CurvePainter(),
          ),
        ),
      ],
    );
  }

  SimpleDialog license(bool isFront) => SimpleDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        title: Text(
          "Back of license image requirements:",
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
                  "The picture must be of the " +
                      (isFront ? "front" : "back") +
                      " of a provisional or full UK driving license.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Text(
                  "-",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                title: Text(
                  "Ensure that there are no marks or blemishes on the iD.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Text(
                  "-",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                title: Text(
                  "Ensure there is no glare and all information is clearly and perfectly visible.",
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
                              style: TextStyle(color: Colors.lightGreenAccent),
                            ),
                            Icon(Icons.check, color: Colors.lightGreenAccent),
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      );

  SimpleDialog passportDialog() => SimpleDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        title: Text(
          "Back of license image requirements:",
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
                  "The picture must be of the FULL identification page on your passport. This page clearly shows your face as well as identity information",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Text(
                  "-",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                title: Text(
                  "Ensure that there are no marks or blemishes on the iD.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Text(
                  "-",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                title: Text(
                  "Ensure there is no glare and all information is clearly and perfectly visible.",
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
                              style: TextStyle(color: Colors.lightGreenAccent),
                            ),
                            Icon(Icons.check, color: Colors.lightGreenAccent),
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      );
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.pink;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.9076);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.825,
        size.width * 0.49, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.9584,
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
