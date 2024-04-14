import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsivetutorial/screens/AppointmentScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOINTMENT_APP',
      home: PensionScreen(),
    );
  }
}

class PensionScreen extends StatefulWidget {
  @override
  _PensionScreenState createState() => _PensionScreenState();
}

class _PensionScreenState extends State<PensionScreen> {
  final List<String> districts = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Moneragala',
    'Ratnapura',
    'Kegalle'
  ];

  String? selectedDistrict;
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    double dropdownWidth = MediaQuery.of(context).size.width *
        0.5; // Set the width of the dropdown

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment for Pension',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 15, 110, 183),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pension.jpg'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
          // Centered content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:
                        dropdownWidth, // Use the calculated width for the dropdown
                    child: DropdownButtonFormField<String>(
                      value: selectedDistrict,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDistrict = newValue;
                          selectedLocation =
                              null; // Reset location on district change
                        });
                      },
                      items: districts
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Your Nearest District',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color.fromARGB(255, 15, 110, 183),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Color.fromARGB(255, 15, 110, 183),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (selectedDistrict != null)
                    ...[
                      '$selectedDistrict Sectarian\'s Office',
                      '$selectedDistrict Divisional Office'
                    ]
                        .map(
                          (location) => Container(
                            width:
                                dropdownWidth, // Set the width to match the dropdown
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // White background for location cards
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(location,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 15, 110, 183))),
                              selected: selectedLocation == location,
                              onTap: () {
                                setState(() {
                                  selectedLocation = location;
                                });
                              },
                              leading: Radio<String>(
                                value: location,
                                groupValue: selectedLocation,
                                onChanged: (value) {
                                  setState(() {
                                    selectedLocation = value;
                                  });
                                },
                                activeColor: Color.fromARGB(255, 15, 110, 183),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedLocation != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentScreen(
                                        selectedDistrict: selectedDistrict!,
                                        selectedLocation: selectedLocation!,
                                        collectionName: "PensionFormData",
                                        title: 'APPOINTMENT FOR PENSION',
                                      )),
                            );
                          }
                        : null,
                    child: Text('Book Appointment',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 15, 110, 183),
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor:
                          Colors.grey.withOpacity(0.12), // Color when disabled
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
