import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    // Determine screen size
    var size = MediaQuery.of(context).size;
    // Check if it's a large screen (arbitrarily set at 600 pixels here, adjust as needed)
    bool isLargeScreen = size.width > 600;

    // Decide which image to use based on the screen width
    String backgroundImage =
        isLargeScreen ? 'assets/welcomeWEB.png' : 'assets/welcome.png';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Text(
                'Welcome to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 39, 129),
                  fontFamily: 'SF Pro Display',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'APPOINTMENT LANKA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 39, 129),
                  fontFamily: 'SF Pro Display',
                ),
              ),
              SizedBox(
                height: 50,
              ),
              CupertinoButton(
                color: Color.fromARGB(255, 34, 39, 129),
                child: Text('Get Started',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    )),
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
