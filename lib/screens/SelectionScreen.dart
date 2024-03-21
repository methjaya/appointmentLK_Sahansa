import 'package:appointmentlksahansa/screens/homescreenAdmin.dart';
import 'package:appointmentlksahansa/screens/homescreenOfficer.dart';
import 'package:flutter/material.dart';
import 'package:appointmentlksahansa/screens/HomeScreen.dart';

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        color: Colors.white,
        child: Stack(
          children: [
            // Gradient Overlay
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /
                  1.2, // Adjust the height as needed
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00A8E8),
                    Color(0xFF01579B),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 1.5 - 200,
                    left: 15,
                    right: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "Select User Type",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle user type selection
                              // You can replace the code below with the actual logic for handling user type
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                            child: Text(
                              "User",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF01579B).withOpacity(0.7),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle officer type selection
                              // You can replace the code below with the actual logic for handling officer type
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreenOfficer()),
                              );
                            },
                            child: Text(
                              "Officer",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF01579B).withOpacity(0.7),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle admin type selection
                              // You can replace the code below with the actual logic for handling admin type
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreenAdmin1()),
                              );
                            },
                            child: Text(
                              "Admin",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF01579B).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Image below the gradient card
            Positioned.fill(
              top: MediaQuery.of(context).size.width / 1.5,
              child: Image.asset(
                'images/select1.jpeg', // Replace with the correct path
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
