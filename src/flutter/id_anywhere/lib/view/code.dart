import 'package:flutter/material.dart';

class CodePage extends StatefulWidget {
  CodePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(),
        Container(
          color: Colors.white,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 296.2),
            painter: CurvePainter(),
          ),
        )
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

    path.moveTo(0, size.height * 0.9000);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.825,
        size.width * 0.513, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.9884,
        size.width * 1, size.height * 0.65);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
