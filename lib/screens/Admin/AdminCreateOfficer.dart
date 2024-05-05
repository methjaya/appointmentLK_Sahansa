import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:AppointmentsbySahansa/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOINTMENT_APP',
      home: CreateUserScreen(),
    );
  }
}

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  void _trySubmitForm() {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      print('Name: $_name, Email: $_email, Password: $_password');
      // Implement your user creation logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    double fieldWidth =
        MediaQuery.of(context).size.width > 600 ? 400 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Officer User',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1981E1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Name',
                            fillColor: Colors.white,
                            filled: true),
                        onSaved: (value) {
                          _name = value ?? '';
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            fillColor: Colors.white,
                            filled: true),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _email = value ?? '';
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Password',
                            fillColor: Colors.white,
                            filled: true),
                        obscureText: true,
                        onSaved: (value) {
                          _password = value ?? '';
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            fillColor: Colors.white,
                            filled: true),
                        obscureText: true,
                        onSaved: (value) {
                          _confirmPassword = value ?? '';
                        },
                        validator: (value) {
                          if (value != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _trySubmitForm,
                      child: Text('Create User'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue[800],
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
