import 'package:AppointmentsbySahansa/screens/Admin/AdminHomeScreen.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminNICScreen.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminOnGoingScreen.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminOnGoingScreen.dart';
import 'package:AppointmentsbySahansa/screens/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:AppointmentsbySahansa/firebase_options.dart';
import 'package:AppointmentsbySahansa/main.dart';
import 'package:AppointmentsbySahansa/screens/Instructions/LicenseInstructions.dart';

import 'package:AppointmentsbySahansa/screens/Instructions/PassportInstructions.dart';
import 'package:AppointmentsbySahansa/screens/Instructions/PensionInstructions.dart';
import 'package:AppointmentsbySahansa/screens/WelcomeScreen.dart';
import 'package:AppointmentsbySahansa/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ReviewOfficerUsersScreen extends StatefulWidget {
  @override
  _ReviewOfficerUsersScreenState createState() =>
      _ReviewOfficerUsersScreenState();
}

class _ReviewOfficerUsersScreenState extends State<ReviewOfficerUsersScreen> {
  List<Map<String, String>> users = [
    {'name': 'John Doe', 'email': 'john.doe@example.com'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alice.johnson@example.com'},
  ];

  String searchQuery = '';

  void showEditDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Officer User",
              style: TextStyle(color: Colors.blue[800])),
          content: UserEditForm(user: user),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteUser(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.blue[800])),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  users.removeWhere((u) => u['email'] == user['email']);
                  Navigator.of(context).pop();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User deleted successfully!"),
                    duration: Duration(seconds: 5),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredUsers = users
        .where((user) =>
            user['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user['email']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    double maxWidth = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Review Officer Users', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Search',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(filteredUsers[index]['name']!),
                          subtitle: Text(filteredUsers[index]['email']!),
                          leading: Icon(Icons.person, color: Colors.blue[800]),
                          onTap: () => showEditDialog(filteredUsers[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteUser(filteredUsers[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// UserEditForm widget definition
class UserEditForm extends StatefulWidget {
  final Map<String, String> user;

  UserEditForm({Key? key, required this.user}) : super(key: key);

  @override
  _UserEditFormState createState() => _UserEditFormState();
}

class _UserEditFormState extends State<UserEditForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user['name']!;
    _emailController.text = widget.user['email']!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Logic to save user details
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Save Changes'),
        ),
      ],
    );
  }
}
