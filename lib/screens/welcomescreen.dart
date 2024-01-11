import 'package:appointmentlksahansa/colors.dart';
import 'package:appointmentlksahansa/screens/homescreen.dart';
import 'package:flutter/material.dart';

class WelcomeSrn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            prColor.withOpacity(0.8),
            prColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset("images/call.png"),
          ),
          SizedBox(height: 70),
          Text(
            "Appointment Lanka by Sahansa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              wordSpacing: 2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Making Government Services Easier",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 100),
          Material(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
        ]),
      ),
    );
  }
}
