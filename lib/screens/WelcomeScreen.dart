import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:AppointmentsbySahansa/screens/UserSelectionScreen.dart';
import 'package:AppointmentsbySahansa/screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/welcome.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text(
                'Welcome to the Government Services Portal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your one-stop destination for managing all government-related appointments.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontFamily: 'SF Pro Text',
                ),
              ),
              Spacer(),
              CupertinoButton(
                color: Colors.white,
                child: Text('Get Started',
                    style: TextStyle(color: Colors.blue[800])),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
