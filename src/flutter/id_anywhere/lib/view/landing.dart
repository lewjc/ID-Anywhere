import 'package:flutter/material.dart';
import 'package:id_anywhere/widgets/ida_button.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override Widget build(BuildContext context) {
    
    return(
      Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IDAnywhereButton(
                      text:"Login",
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    IDAnywhereButton(
                      text: "Sign up",
                      onPressed: () => Navigator.pushNamed(context, '/login')
                    )
                  ],
                )
              ],
            )
          ],
        )
      ,)
    );
  }
}