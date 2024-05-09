import 'package:AppointmentsbySahansa/screens/OfficerLogin.dart';
import 'package:AppointmentsbySahansa/screens/loginScreen.dart';
import 'package:AppointmentsbySahansa/screens/Adminlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AppointmentsbySahansa/homepage.dart';
import 'package:AppointmentsbySahansa/main.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminHomeScreen.dart';
import 'package:AppointmentsbySahansa/screens/Officer/OfficerHomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserSelectionScreen(),
    );
  }
}

class UserSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select User Role",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/selection.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [Colors.blue[600]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: screenWidth > 800 ? 800 : screenWidth * 0.9,
            height: screenHeight > 600 ? 600 : screenHeight * 0.7,
            alignment: Alignment.center,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
              padding: EdgeInsets.all(20),
              children: <Widget>[
                RoleCard(
                  role: "Citizen",
                  icon: Icons.people,
                  navigationPage: LoginScreen(), //HomeScreen(),
                ),
                RoleCard(
                  role: "Officer",
                  icon: Icons.security,
                  navigationPage: OfficerLogin(), //OfficerHomeScreen(),
                ),
                RoleCard(
                  role: "Admin",
                  icon: Icons.admin_panel_settings,
                  navigationPage: AdminLogin(), //AdminHomeScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String role;
  final IconData icon;
  final Widget navigationPage;

  const RoleCard({
    Key? key,
    required this.role,
    required this.icon,
    required this.navigationPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigationPage),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue[800]),
            SizedBox(height: 8),
            Text(
              role,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreenAdmin extends StatefulWidget {
  const LoginScreenAdmin({Key? key}) : super(key: key);

  @override
  _LoginScreenAdminState createState() => _LoginScreenAdminState();
}

class _LoginScreenAdminState extends State<LoginScreenAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width *
        0.5; // Set width to 50% of screen width

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => UserSelectionScreen())),
        ),
      ),
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
                    "Welcome Back!",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
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
          if (hintText == 'Password' && value.length < 6) {
            return 'Password must be at least 6 characters';
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
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => UserSelectionScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')));
      setState(() {
        isLoading = false;
      });
    }
  }
}
