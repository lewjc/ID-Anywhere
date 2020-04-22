import 'package:flutter/material.dart';

enum MediaOption{
  CAMERA, 
  GALLERY
}

class MediaHelper{
  static Future<MediaOption> getUserMediaChoice(BuildContext context) async{
    return await showDialog(
      context: context,
      builder: (_) => new SimpleDialog(
        title: Text("Select media"),
        children: <Widget>[ 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[             
              Expanded(
                child:  SimpleDialogOption(
                  onPressed: (){ Navigator.pop(context, MediaOption.CAMERA);},
                  child: Icon(Icons.camera),
                ),
              ),
              Expanded(
                child: SimpleDialogOption(
                  onPressed: (){ Navigator.pop(context, MediaOption.GALLERY);},            
                  child: Icon(Icons.image )
                ),  
              ),
            ],
          ),
        ],
      ),
    );
  }
}