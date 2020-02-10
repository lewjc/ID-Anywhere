import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:id_anywhere/constants/flags.dart';
import 'package:id_anywhere/enum/verification_status.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/service_result.dart';
import 'package:id_anywhere/service/signup_service.dart';
import 'package:id_anywhere/widgets/ida_button.dart';
import 'package:id_anywhere/widgets/ida_textinput.dart';
import 'package:id_anywhere/widgets/ida_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      FocusScope.of(context).unfocus();
      ServiceResult result =
          await service.executeSignup(firstName, lastName, email, password);

      if (result.valid()) {
        // If we are successful, ask if they would like to setup biometric identification for login.
        scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Sign up successful",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2)));

        // Now, here we should ask the user to register biometric login.
        // store the username and password in firebase, then when biometric success, grab those and post them.
        await service.storeDetailsInFirebase(email, password);
        final secureStorage = resolver<FlutterSecureStorage>();
        await secureStorage.write(key: Flags.verificationStatus, value: VerificationStatus.UNVERIFIED);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => dialog());
      } else {
        for (final error in result.errors) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                error,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),  
              backgroundColor: Colors.yellow,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          key: scaffoldKey,
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
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IDAnywhereButton(text: "Submit", onPressed: submit),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void allowBiometricIdentification({bool allow = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Flags.useLocalAuth, allow);
    Navigator.popAndPushNamed(context, "/login");
  }

  @override
  void dispose() {
    this.emailController.dispose();
    this.firstNameController.dispose();
    this.lastNameController.dispose();
    this.passwordController.dispose();
    super.dispose();
  }

  SimpleDialog dialog() => SimpleDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        title: Text(
          "Biometric Identification",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 5),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "Would you like to use local biometric identification for this account?",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: SimpleDialogOption(
                        onPressed: () => allowBiometricIdentification(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Yes",
                              style: TextStyle(color: Colors.lightGreenAccent),
                            ),
                            Icon(Icons.check, color: Colors.lightGreenAccent),
                          ],
                        )),
                  ),
                  Expanded(
                    child: SimpleDialogOption(
                        onPressed: () =>
                            allowBiometricIdentification(allow: false),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("No",
                                style: TextStyle(color: Colors.redAccent)),
                            Icon(Icons.block, color: Colors.redAccent)
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      );
}
