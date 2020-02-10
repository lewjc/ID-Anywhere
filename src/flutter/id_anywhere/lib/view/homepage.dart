import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id_anywhere/view/code.dart';
import 'package:id_anywhere/view/profile.dart';
import 'package:id_anywhere/view/upload.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> onBackPress() async {
    await SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPress,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                elevation: 10,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("ID Anywhere",
                        style: TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(5.0, 5.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(20, 0, 0, 0),
                            ),
                            Shadow(
                              offset: Offset(5.0, 5.0),
                              blurRadius: 8.0,
                              color: Color.fromARGB(0, 0, 0, 0),
                            ),
                          ],
                        ))
                  ],
                ),
                bottom: TabBar(tabs: [
                  Tab(text: "Profile", icon: Icon(Icons.account_circle)),
                  Tab(
                    text: "Upload",
                    icon: Icon(Icons.cloud_upload),
                  ),
                  Tab(text: "My iD", icon: Icon(Icons.remove_red_eye)),
                ]),
              ),
              body: TabBarView(
                children: [
                  ProfilePage(),
                  UploadPage(),
                  CodePage()
                  // these are your pages
                ],
                
              ),
              key: _scaffoldKey,
              backgroundColor: Colors.white,
            )));
  }
}



class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.pink;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
