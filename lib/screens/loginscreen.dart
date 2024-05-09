import 'package:AppointmentsbySahansa/screens/NICScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AppointmentsbySahansa/main.dart';
import 'package:AppointmentsbySahansa/screens/UserSelectionScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedDistrict;
  bool isLoading = false;
  bool isLogin = true; // Toggle between login and register

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(), // Adding the email explicitly
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'nic': _nicController.text.trim(),
        'phone': _phoneController.text.trim(),
        'district': _selectedDistrict,
      });

      setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')));
      setState(() {
        isLoading = false;
      });
    }
  }

  final List<String> districts = [
    "Ampara",
    "Anuradhapura",
    "Badulla",
    "Batticaloa",
    "Colombo",
    "Galle",
    "Gampaha",
    "Hambantota",
    "Jaffna",
    "Kalutara",
    "Kandy",
    "Kegalle",
    "Kilinochchi",
    "Kurunegala",
    "Mannar",
    "Matale",
    "Matara",
    "Monaragala",
    "Mullaitivu",
    "Nuwara Eliya",
    "Polonnaruwa",
    "Puttalam",
    "Ratnapura",
    "Trincomalee",
    "Vavuniya"
  ];

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
                    isLogin ? "Welcome Back!" : "Register",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  if (!isLogin)
                    buildTextField(_firstNameController, '  First Name',
                        Icons.person, width),
                  if (!isLogin) const SizedBox(height: 20),
                  if (!isLogin)
                    buildTextField(
                        _lastNameController, 'Last Name', Icons.person, width),
                  if (!isLogin) const SizedBox(height: 20),
                  if (!isLogin)
                    buildTextField(
                        _nicController, 'NIC', Icons.credit_card, width),
                  if (!isLogin) const SizedBox(height: 20),
                  if (!isLogin) buildDropdown(width),
                  if (!isLogin) const SizedBox(height: 20),
                  if (!isLogin)
                    buildTextField(
                        _phoneController, 'Phone Number', Icons.phone, width),
                  if (!isLogin) const SizedBox(height: 20),
                  buildTextField(_emailController, 'Email', Icons.email, width),
                  const SizedBox(height: 20),
                  buildTextField(
                      _passwordController, 'Password', Icons.lock, width,
                      isPassword: true),
                  if (!isLogin) const SizedBox(height: 20),
                  if (!isLogin)
                    buildTextField(_confirmPasswordController,
                        'Confirm Password', Icons.lock, width,
                        isPassword: true),
                  const SizedBox(height: 40),
                  isLoading
                      ? const CircularProgressIndicator()
                      : buildButton(isLogin ? 'LOGIN' : 'REGISTER', width),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin =
                            !isLogin; // Toggle between login and registration mode
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'Need an account? Register'
                          : 'Have an account? Login',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => UserSelectionScreen()),
                      );
                    },
                    child: Text(
                      'Go Back',
                      style: TextStyle(color: Colors.white70),
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
              borderSide: BorderSide.none),
          prefixIcon: Icon(icon),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText cannot be empty';
          }
          switch (hintText) {
            case 'Email':
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              break;
            case 'NIC':
              if (value.length != 12) {
                return 'NIC must be 12 characters long';
              }
              break;
            case 'Phone Number':
              if (value.length != 10) {
                return 'Phone number must be 10 digits long';
              }
              break;
            case 'Password':
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              break;
            case 'Confirm Password':
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              break;
          }
          return null;
        },
      ),
    );
  }

  Widget buildDropdown(double width) {
    return Container(
      width: width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
        ),
        value: _selectedDistrict,
        hint: Text("Select District"),
        onChanged: (String? newValue) {
          setState(() {
            _selectedDistrict = newValue!;
          });
        },
        validator: (value) => value == null ? 'Please select a district' : null,
        items: districts.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildButton(String text, double width) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (isLogin) {
              _login();
            } else {
              _register();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue[800],
          backgroundColor: Colors.white,
          minimumSize: Size(width, 50),
        ),
        child:
            Text(text, style: TextStyle(color: Colors.blue[800], fontSize: 16)),
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
      // Navigate to home screen or handle successful login
      setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen())); //
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')));
      setState(() {
        isLoading = false;
      });
    }
  }
}
