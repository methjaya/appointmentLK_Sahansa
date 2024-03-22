import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, String> _userData = {
    'name': 'Sahansa Jayawardhana',
    'nic': '200115600799',
    'email': 'methjaya252@gmail.com',
  };

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF01579B),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A8E8), Color(0xFF01579B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: ClipOval(
                child:
                    Image.asset("images/mying1.jpg", height: 100, width: 100),
              ),
            ),
            SizedBox(height: 30),
            _userInfoTile('Name', _userData['name'] ?? ''),
            _userInfoTile('NIC', _userData['nic'] ?? ''),
            _userInfoTile('Email', _userData['email'] ?? ''),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _showChangePasswordDialog,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF01579B),
                  backgroundColor: Colors.white, // foreground
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userInfoTile(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '$title: $value',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password',
              style: TextStyle(color: Color(0xFF01579B))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _passwordField('Current Password', _currentPasswordController),
                _passwordField('New Password', _newPasswordController),
                _passwordField(
                    'Re-enter New Password', _confirmNewPasswordController),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF01579B))),
            ),
            TextButton(
              onPressed: () {
                // Implement password update logic here
                Navigator.of(context).pop();
              },
              child: Text('Change', style: TextStyle(color: Color(0xFF01579B))),
            ),
          ],
        );
      },
    );
  }

  Widget _passwordField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF01579B)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF01579B)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
