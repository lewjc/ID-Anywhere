import 'package:flutter/material.dart';
import 'package:id_anywhere/service/service_registration.dart';
import 'package:id_anywhere/view/homepage.dart';
import 'package:id_anywhere/view/login.dart';
import 'package:id_anywhere/view/signup.dart';
import 'package:global_configuration/global_configuration.dart';
import 'view/landing.dart';

void main() async{
  setupDependencies();
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'ID Anywhere',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,  
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => LandingPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}