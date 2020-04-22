import 'dart:async';

import 'package:flutter/material.dart';
import 'package:id_anywhere/service/code_service.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CodePage extends StatefulWidget {
  CodePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> with AutomaticKeepAliveClientMixin{

  String code;
  bool active = false;
  final codeService = resolver<CodeService>();

  @override
  bool get wantKeepAlive => true;

  Timer _timer;
  int _time = 15;

  void startTimer() {    
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_time < 1) {
            timer.cancel();
            timer = null;
            active = false;
            code = null;
          } else {
            _time = _time - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void getCode() async {
    var code = await codeService.getCode();

    if(code == null){
      // Show error
    } else {
      this.setState(() {
        this.code = code;
        this.active = true;
        this._time = 15;
      });
      startTimer();
    }
  }

  QrImage displayCode (data) => QrImage(
    data: data,
    version: QrVersions.auto,
    size: 300.0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Spacer(flex: 2),
        this.active ? 
        Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: new Border.all(
              width: 5
            ),
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 5)
            ],
          ),
          child: displayCode(this.code),
          height: 350,
          width: 350, 
        )
        : 
        InkWell(
          child: ButtonTheme(
            splashColor: Colors.pinkAccent[100],
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
          minWidth: 150.0,
          height: 75.0,
            child: RaisedButton(                    
              color: Colors.pinkAccent,
              textColor: Colors.white,          
              onPressed: getCode,
              child: const Text(
                'Generate Code',
                style: TextStyle(fontSize: 20)
              ),
            ),
          ),
        ),
        Spacer(flex: active ? 5 : 1),        
        if(this.active) 
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Code valid for $_time seconds",
              style: TextStyle(
                color: Colors.pink,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Open Sans"
                ),
              )
            ],
          ),
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
