import 'package:flutter/material.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/verify_passport.dart';
import 'package:id_anywhere/widgets/ida_upload_card.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    // Here we need to do a lot of work.

    /**
   * 
   * This will have the upload container for the license, the back of the license and the passport photo.
   * 
   *  For each upload, we need to:
   *  Scan the picture, see if it fufills certain business requirements for the ID. Then
   *  information is extracted from the image, turned into a model and sent to the upload portion of the API.
   *  there the information is stored into mongo. If this all succeeds, 
   *  then we will also upload the photo to cloud. From there, 
   *  a flag can be set to say that the upload is verified
   * 
   * 
   * 
   */

    final service = resolver<VerifyPassportService>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30),
        IDAnywhereUploadCard(
            title: 'Driving License Front',
            validateImageCallback: service.verify),
        IDAnywhereUploadCard(title: 'Driving License Back'),
        IDAnywhereUploadCard(title: 'Passport'),
        Container(
          color: Colors.white,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 248.16),
            painter: CurvePainter(),
          ),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.pink;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.89);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.775,
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
