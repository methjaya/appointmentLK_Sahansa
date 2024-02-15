import 'package:appointmentlksahansa/screens/ddNIC.dart';
import 'package:appointmentlksahansa/screens/ddPassport.dart';
import 'package:appointmentlksahansa/screens/homescreen.dart';
import 'package:appointmentlksahansa/screens/openScreen.dart';
import 'package:appointmentlksahansa/screens/welcomescreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeSrn(),
        '/page1': (context) => OpenScreen(),
        '/page2': (context) => WelcomeSrn(),
        '/page3': (context) => HomeScreen(),
        '/page4': (context) => WelcomeSrn(),
        '/page5': (context) => ddPassport(),
        '/page6': (context) => ddNIC(),
      },
    );
  }
}
