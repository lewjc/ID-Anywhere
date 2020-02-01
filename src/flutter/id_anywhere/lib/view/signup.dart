import 'package:flutter/material.dart';
import 'package:id_anywhere/widgets/ida_button.dart';
import 'package:id_anywhere/widgets/ida_textinput.dart';
import 'package:id_anywhere/widgets/ida_title.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void submit() {
    _formKey.currentState.validate();
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
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IDAnywhereTitle(text: 'Sign up'),
                ],
              ),
              Spacer(flex: 3),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IDAnywhereTextField(
                        hint: 'First Name',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter first name';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      IDAnywhereTextField(
                        hint: 'Last Name',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter last name';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  IDAnywhereTextField(
                      hint: 'Email',
                      validator: (value) => 'true',
                      width: 300,
                      controller: emailController),
                  SizedBox(height: 20),
                  IDAnywhereTextField(
                    hint: 'Confirm email',
                    validator: (value) => 'true',
                    width: 300,
                  ),
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
                  SizedBox(height: 20),
                  IDAnywhereTextField(
                    hint: 'Confirm Password',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please confirm password';
                      } else if (value.toLowerCase() !=
                          this.passwordController.text.toLowerCase()) {
                        return 'Password does not match';
                      } else {
                        return null;
                      }
                    },
                    width: 300,
                    passwordField: true,
                  ),
                ],
              ),
              Spacer(
                flex: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IDAnywhereButton(text: "Submit", onPressed: submit),
                ],
              ),
              Spacer(),
            ],
          ),
        ));
  }
}
