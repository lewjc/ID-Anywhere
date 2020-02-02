import 'package:flutter/material.dart';
import 'package:id_anywhere/service/signup_service.dart';
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

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final service = SignupService();

  void submit() async {
    if (_formKey.currentState.validate()) {
      // Form is all okay, we can get our values and create the account.
      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      bool successful =
          await service.executeSignup(firstName, lastName, email, password);

      if (successful) {
        // If we are successful, ask if they would like to setup biometric identification for login.
        
      }
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
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IDAnywhereTitle(text: 'Sign up'),
                ],
              ),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IDAnywhereTextField(
                        hint: 'First Name',
                        controller: firstNameController,
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
                        controller: lastNameController,
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
                    hint: 'Confirm email',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please confirm email';
                      } else if (value.toLowerCase() !=
                          this.emailController.text.toLowerCase()) {
                        return 'Email does not match';
                      } else {
                        return null;
                      }
                    },
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
              SizedBox(height: 50),
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

  @override
  void dispose() {
    this.emailController.dispose();
    this.firstNameController.dispose();
    this.lastNameController.dispose();
    this.passwordController.dispose();
    super.dispose();
  }
}
