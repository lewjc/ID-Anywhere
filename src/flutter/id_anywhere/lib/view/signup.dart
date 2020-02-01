import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return (Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.pink,
        body: Column(        
          children: <Widget>[
            Row(
              children: <Widget>[
                TextFormField( 
                  decoration: InputDecoration(labelText: 'First name'),
                ),
                TextFormField(
                  key: _formKey,
                  decoration: InputDecoration(labelText: 'Last name'),
                )
              ],
            ),
            SizedBox(height: 100),
            Row(
              children: <Widget>[
                TextFormField(
                  key: _formKey,
                  decoration: InputDecoration(labelText: 'First name'),
                ),
                TextFormField(
                  key: _formKey,
                  decoration: InputDecoration(labelText: 'Last name'),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
