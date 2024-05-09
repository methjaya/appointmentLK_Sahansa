import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReviewOfficerUsersScreen(),
    );
  }
}

class ReviewOfficerUsersScreen extends StatefulWidget {
  @override
  _ReviewOfficerUsersScreenState createState() =>
      _ReviewOfficerUsersScreenState();
}

class _ReviewOfficerUsersScreenState extends State<ReviewOfficerUsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name':
                      '${doc.data()['firstName'] ?? ''} ${doc.data()['lastName'] ?? ''}'
                          .trim(),
                  'email': doc.data()['email'] ?? 'No email provided'
                })
            .toList());
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width > 600
                      ? 400
                      : double.infinity,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
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
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No users found',
                            style: TextStyle(color: Colors.white)));
                  }
                  var filteredUsers = snapshot.data!
                      .where((user) =>
                          user['name']
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()) ||
                          user['email']
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      String displayName = filteredUsers[index]['name'];
                      String displayEmail = filteredUsers[index]['email'];
                      if (displayName.length > 25) {
                        displayName = displayName.substring(0, 25) + '...';
                      }
                      if (displayEmail.length > 30) {
                        displayEmail = displayEmail.substring(0, 30) + '...';
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width > 600
                              ? 185
                              : 50,
                          right: MediaQuery.of(context).size.width > 600
                              ? 185
                              : 50,
                        ),
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            title: Text(displayName,
                                style: TextStyle(color: Colors.blue[800])),
                            subtitle: Text(displayEmail,
                                style: TextStyle(color: Colors.black)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.green),
                                  onPressed: () =>
                                      showEditDialog(filteredUsers[index]),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      confirmDeleteDialog(filteredUsers[index]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEditDialog(Map<String, dynamic> user) {
    TextEditingController nameController =
        TextEditingController(text: user['name']);
    TextEditingController emailController =
        TextEditingController(text: user['email']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                updateUser(
                    user['id'], nameController.text, emailController.text);
                Navigator.of(context).pop();
              },
              child:
                  Text('Save Changes', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void updateUser(String userId, String name, String email) {
    var names = name.split(' ');
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'firstName': names.first,
      'lastName': names.length > 1 ? names.sublist(1).join(' ') : '',
      'email': email
    });
  }

  void confirmDeleteDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.blue[800])),
            ),
            TextButton(
              onPressed: () {
                deleteUser(user['id']);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
}
