import 'package:flutter/material.dart';

class IDAnywhereTitle extends StatelessWidget {

  IDAnywhereTitle({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(this.text,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontFamily: 'Open Sans',
            fontSize: 70));
  }
}
