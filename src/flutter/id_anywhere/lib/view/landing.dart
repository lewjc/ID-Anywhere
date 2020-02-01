import 'package:flutter/material.dart';
import 'package:id_anywhere/widgets/ida_button.dart';
import 'package:id_anywhere/widgets/ida_title.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        backgroundColor: Colors.pink,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IDAnywhereTitle(text: 'ID Anywhere'),
                SizedBox(height: 10),
                Text(
                  'A digital identification solution',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IDAnywhereButton(
                      text: "Login",
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    IDAnywhereButton(
                        text: "Sign up",
                        onPressed: () => Navigator.pushNamed(context, '/signup'))
                  ],
                ),
                SizedBox(height: 500),
              ],
            )
          ],
        )));
  }
}
