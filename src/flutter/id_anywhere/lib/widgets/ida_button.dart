import 'package:flutter/material.dart';

class IDAnywhereButton extends StatelessWidget{

  IDAnywhereButton({Key key, this.text, this.onPressed}) : super(key: key);

  final String text;

  final Function onPressed;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 250,
      height: 50,      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.pink,
          width: 1,
        ),
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9)), 
        color: Colors.white,  
        onPressed: this.onPressed,        
        highlightColor: Colors.pink,              
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              this.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black
              ),
            ),
          ],
        ), 
      ),
    );
  }
}