import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    double width = MediaQuery.of(context).size.width *
        0.5; // Set width to 50% of screen width

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
                  const FlutterLogo(size: 100), // Optional logo
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
                    buildTextField(_firstNameController, 'First Name',
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
          if (hintText == 'Email' && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (hintText == 'NIC' && value.length != 12) {
            return 'NIC must be 12 characters long';
          }
          if (hintText == 'Phone Number' && value.length != 10) {
            return 'Phone number must be 10 digits long';
          }
          if (hintText == 'Confirm Password' &&
              value != _passwordController.text) {
            return 'Passwords do not match';
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) =>
              HomeScreen())); // Assuming HomeScreen is your home page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to home screen or handle successful registration
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) =>
              HomeScreen())); // Assuming HomeScreen is your home page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')));
      setState(() {
        isLoading = false;
      });
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Welcome Home!"),
      ),
    );
  }
}
