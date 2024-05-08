import 'package:AppointmentsbySahansa/screens/Admin/AdminCreateOfficer.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminNICScreen.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminOnGoingScreen.dart';
import 'package:AppointmentsbySahansa/screens/Admin/ReviewOfficerUserScreen.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';

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
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AdminHomeScreen();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}

// //
class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreen createState() => _AdminHomeScreen();
}

class _AdminHomeScreen extends State<AdminHomeScreen> {
  String _searchQuery = '';

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Map<String, dynamic>> _filterServices() {
    if (_searchQuery.isEmpty) return services;
    return services
        .where((service) =>
            service['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var filteredServices = _filterServices();

    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HeaderSection(),
            ),
            SearchBar(onSearch: _handleSearch),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[300]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    DashboardSection(),
                    ManageUsersSection(),
                    AppointmentTitleSection(),
                    MakeAppointmentSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageUsersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Manage Users',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection:
              Axis.horizontal, // Set scroll direction to horizontal
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserManagementCard(
                title: 'Create an Office User',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateUserScreen(),
                    ),
                  );
                },
              ),
              SizedBox(width: 20), // Space between cards
              UserManagementCard(
                title: 'Review Officer Users',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewOfficerUsersScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserManagementCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const UserManagementCard(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue[800],
        backgroundColor: Colors.white, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 2,
        child: TextField(
          controller: _controller,
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search Here',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

// //

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left:
                      20), // increIncrease left padding for the notification icon
              child: IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminOngoingScreen(),
                      ));
                  // Handle notification icon press here
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/officer_avatar.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: 20), // Increase right padding for the logout icon
              child: IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  //FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Hi, Admin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        Text(
          'Manage The Government Service Bookings Easily & Conveniently.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class DashboardSection extends StatefulWidget {
  @override
  _DashboardSectionState createState() => _DashboardSectionState();
}

class _DashboardSectionState extends State<DashboardSection> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchData() async {
    Map<String, dynamic> data = {};

    // Fetching total user count
    var usersSnapshot = await firestore.collection('users').get();
    data['Total Users'] = usersSnapshot.docs.length.toString();

    // Fetching NIC bookings
    var nicSnapshot = await firestore.collection('NICFormData').get();
    data['NIC Bookings'] = nicSnapshot.docs.length.toString();

    // Fetching Passport bookings
    var passportSnapshot = await firestore.collection('PassportFormData').get();
    data['Passport Bookings'] = passportSnapshot.docs.length.toString();

    // Fetching License bookings
    var licenseSnapshot = await firestore.collection('LicenseFormData').get();
    data['License Bookings'] = licenseSnapshot.docs.length.toString();

    // Fetching Pension bookings
    var pensionSnapshot = await firestore.collection('PensionFormData').get();
    data['Pension Bookings'] = pensionSnapshot.docs.length.toString();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 20),
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          var data = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardCard(title: 'Total Users', value: data['Total Users']),
                SizedBox(width: 20),
                DashboardCard(
                    title: 'NIC Bookings', value: data['NIC Bookings']),
                SizedBox(width: 20),
                DashboardCard(
                    title: 'Passport Bookings',
                    value: data['Passport Bookings']),
                SizedBox(width: 20),
                DashboardCard(
                    title: 'License Bookings', value: data['License Bookings']),
                SizedBox(width: 20),
                DashboardCard(
                    title: 'Pension Bookings', value: data['Pension Bookings']),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const DashboardCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentTitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        'Review Appointments',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}

class MakeAppointmentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardSize = screenWidth > 800 ? screenWidth * 0.3 : screenWidth * 0.5;
    double maxWidth = screenWidth * 0.9;

    return Expanded(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Align card in the center
            children: [
              GestureDetector(
                // Gesture detector to handle the tap on the card,
                onTap: () {
                  // Navigate to AdminOngoingScreen when the card is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminOngoingScreen()),
                  );
                },
                child: Container(
                  width: cardSize,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          image: AssetImage(
                              'assets/nic.jpg'), // Replace with an appropriate image asset
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.black.withOpacity(0.5),
                          child: Text(
                            'Click to Select',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  16, // Adjusted font size for better visibility
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> ongoingAppointments = [
  {
    'date': '2024-04-12',
    'time': '10:00 AM',
    'description': 'NIC Application Review',
    'icon': Icons.account_circle,
  },
  {
    'date': '2024-04-15',
    'time': '02:00 PM',
    'description': 'Passport Collection Appointment',
    'icon': Icons.book_online,
  },
  {
    'date': '2024-04-18',
    'time': '09:00 AM',
    'description': 'Driving License Renewal',
    'icon': Icons.directions_car,
  },
];
