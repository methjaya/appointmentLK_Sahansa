import 'package:flutter/material.dart';

class NICScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NIC Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF00A8E8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00A8E8),
              Color(0xFF01579B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card,
                color: Colors.white,
                size: 50,
              ),
              SizedBox(height: 20),
              Text(
                'National Identity Card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your National Identity Card (NIC) is a crucial document for identification purposes. It contains essential information such as your name, date of birth, and a unique identification number.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/page7');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 31, 100, 169), // Set button color
                ),
                child: Text(
                  'What Should You Bring ??',
                  style: TextStyle(color: Colors.white), // Set text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
