import 'package:flutter/material.dart';
import 'package:id_anywhere/service/login_service.dart';
import 'package:id_anywhere/widgets/ida_button.dart';
import 'package:id_anywhere/widgets/ida_textinput.dart';
import 'package:id_anywhere/widgets/ida_title.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final service = LoginService();

  void login() {
    if (_formKey.currentState.validate()) {
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.pink,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 150),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IDAnywhereTitle(text: 'Login'),
                ],
              ),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  IDAnywhereTextField(
                      hint: 'Email',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        }

                        return null;
                      },
                      width: 300,
                      controller: emailController),
                  SizedBox(height: 20),
                  IDAnywhereTextField(
                      hint: 'Password',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }

                        return null;
                      },
                      width: 300,
                      passwordField: true,
                      controller: passwordController),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IDAnywhereButton(text: "Submit", onPressed: login),
                      RawMaterialButton(
                        onPressed: () {},
                        highlightColor: Colors.pink,
                        child: new Icon(
                          Icons.fingerprint, 
                          color: Colors.black,
                          size: 40.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 10.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(5.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
