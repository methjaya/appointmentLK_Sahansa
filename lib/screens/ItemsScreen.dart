import 'package:flutter/material.dart';
import 'HomeScreen.dart'; // Import your home screen file

class ItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Read Carefully !',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF00A8E8),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'What Should You Bring?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                _buildIconRow(
                  Icons.description,
                  'Birth Certificate (Original)',
                ),
                _buildIconRow(
                  Icons.photo_camera,
                  'Photo Confirmation Receipt issued from a Certified Photographer',
                ),
                _buildIconRow(
                  Icons.edit,
                  'Certified Documents by Grama Niladhari Officer',
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(), // Replace HomeScreen with your actual home screen file
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 31, 100, 169),
                  ),
                  child: Text(
                    'Go Back to Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
