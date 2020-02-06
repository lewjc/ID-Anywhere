import 'package:flutter/material.dart';
import 'package:id_anywhere/constants/flags.dart';
import 'package:id_anywhere/service/local_authentication_service.dart';
import 'package:id_anywhere/service/login_service.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/service/service_result.dart';
import 'package:id_anywhere/widgets/ida_button.dart';
import 'package:id_anywhere/widgets/ida_textinput.dart';
import 'package:id_anywhere/widgets/ida_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final service = LoginService();

  void login() {
    if (_formKey.currentState.validate()) {
      service.executeLogin(emailController.text, passwordController.text);
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await attemptLocalAuth();
    });
  }

  Future<bool> attemptLocalAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(Flags.useLocalAuth) ?? false) {
      final LocalAuthenticationService _localAuth =
          resolver<LocalAuthenticationService>();
      bool authorised =
          await _localAuth.authenticate("Use fingerprint to login");

      if (authorised) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                      // Aligns the container to center
                      child: Container(
                    // A simplified version of dialog.
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Securely logging you in..",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                        SizedBox(height: 30),
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  )),
                ));
        // Execute login, by getting the details from the firebase datastore attached to the hashed application ID.
        ServiceResult result = await service.loginFromLocalAuth();
        if (result.valid()) {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
        } else {
          // Snackbar, login failed for some reason. Try manual or say try again later.
          for (final error in result.errors) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  error,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.yellow,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2)));
          }
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Form(
            key: _formKey,
            child: Scaffold(
              key: _scaffoldKey,
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
                            onPressed: attemptLocalAuth,
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
                        children: <Widget>[],
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
