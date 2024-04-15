import 'package:flutter/material.dart';
import 'package:responsivetutorial/homepage.dart';
import 'package:responsivetutorial/main.dart';
import 'package:responsivetutorial/screens/OfficerHomeScreen.dart';

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
                  navigationPage: HomeScreen(),
                ),
                RoleCard(
                  role: "Officer",
                  icon: Icons.security,
                  navigationPage: OfficerHomeScreen(),
                ),
                RoleCard(
                  role: "Admin",
                  icon: Icons.admin_panel_settings,
                  navigationPage: AdminPage(),
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

// Example pages for each role
class CitizenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Citizen Page')),
      body: Center(child: Text('Welcome, Citizen!')),
    );
  }
}

class OfficerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Officer Page')),
      body: Center(child: Text('Welcome, Officer!')),
    );
  }
}

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Page')),
      body: Center(child: Text('Welcome, Admin!')),
    );
  }
}
