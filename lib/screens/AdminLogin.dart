import 'package:AppointmentsbySahansa/screens/Admin/AdminHomeScreen.dart';
import 'package:AppointmentsbySahansa/screens/UserSelectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AppointmentsbySahansa/main.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminHomeScreen.dart'; // Import the AdminHomeScreen

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[300]!, Colors.blue[800]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  Text(
                    "Admin Login",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField(_emailController, 'Email', Icons.email, width),
                  const SizedBox(height: 20),
                  buildTextField(
                      _passwordController, 'Password', Icons.lock, width,
                      isPassword: true),
                  const SizedBox(height: 40),
                  isLoading
                      ? const CircularProgressIndicator()
                      : buildButton('LOGIN', width),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => UserSelectionScreen()),
                      );
                    },
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText,
      IconData icon, double width,
      {bool isPassword = false}) {
    return Container(
      width: width,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText cannot be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget buildButton(String text, double width) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _login();
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue[800],
          backgroundColor: Colors.white,
          minimumSize: Size(width, 50),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.blue[800], fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if the user is an admin (You need to implement this logic)
      // For example, you can check a field in Firestore or a custom claim.
      // For now, assuming all users are admins for demonstration purposes.
      if (userCredential.user != null) {
        // Navigate to admin home screen
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => AdminHomeScreen()));
      } else {
        // Handle non-admin user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not authorized to login as admin.')),
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
