import 'package:appointmentlksahansa/screens/ItemsScreen.dart';
import 'package:appointmentlksahansa/screens/ItemsScreen2.dart';
import 'package:appointmentlksahansa/screens/SelectionScreen.dart';
import 'package:appointmentlksahansa/screens/ddNIC.dart';
import 'package:appointmentlksahansa/screens/ddPassport.dart';
import 'package:appointmentlksahansa/screens/homescreen.dart';
import 'package:appointmentlksahansa/screens/homescreenAdmin.dart';
import 'package:appointmentlksahansa/screens/homescreenOfficer.dart';
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
        '/page7': (context) => ItemsScreen(),
        '/page8': (context) => ItemsScreen2(),
        '/page9': (context) => SelectionScreen(),
        '/page10': (context) => HomeScreenOfficer(),
        '/page11': (context) => HomeScreenAdmin1(),
      },
    );
  }
}
