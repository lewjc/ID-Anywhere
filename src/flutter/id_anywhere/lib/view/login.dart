import 'package:flutter/material.dart';
import 'package:id_anywhere/widgets/ida_button.dart';
import 'package:id_anywhere/widgets/ida_textinput.dart';
import 'package:id_anywhere/widgets/ida_title.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void login() {
    if(_formKey.currentState.validate()){
      
    }
  }

  @override Widget build(BuildContext context) {
    
    return Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.pink,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IDAnywhereTitle(text: 'Login'),
                  SizedBox(height: 100),
                  IDAnywhereTextField(
                    hint: 'Email',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter email';
                      } 
                        return null;                      
                    },
                    width: 300,
                  ),
                  SizedBox(height: 25),
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
                ],
              ),                        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IDAnywhereButton(text: "Login", onPressed: login),
                ],
              ),              
            ],
          ),
        ));
  }
}