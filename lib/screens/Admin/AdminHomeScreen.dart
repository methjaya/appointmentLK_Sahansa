import 'package:AppointmentsbySahansa/screens/Admin/AdminCreateOfficer.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminNICScreen.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminOnGoingScreen.dart';
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
                    MakeAppointmentSection(filteredServices: filteredServices),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

class DashboardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DashboardCard(title: 'Total Users', value: '1,234'),
            SizedBox(width: 20),
            DashboardCard(title: 'NIC Bookings', value: '340'),
            SizedBox(width: 20),
            DashboardCard(title: 'Passport Bookings', value: '212'),
            SizedBox(width: 20),
            DashboardCard(title: 'License Bookings', value: '89'),
            SizedBox(width: 20),
            DashboardCard(title: 'Pension Bookings', value: '58'),
          ],
        ),
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
        'View the Appointments',
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
  final List<Map<String, dynamic>> filteredServices;

  const MakeAppointmentSection({Key? key, required this.filteredServices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardSize = screenWidth > 800 ? screenWidth * 0.3 : screenWidth * 0.5;
    double maxWidth = screenWidth * 0.9;
    final ScrollController scrollController = ScrollController();

    return Expanded(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset - cardSize,
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 300),
                  );
                },
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredServices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigation logic based on service type
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              switch (filteredServices[index]['type']) {
                                case 'NIC':
                                  return AdminNICScreen(); // Or NICScreen if it's more appropriate
                                case 'Passport':
                                  return PassportInstructions();
                                case 'License':
                                  return LicenseInstructions();
                                case 'Pension':
                                  return PensionInstructions();
                                default:
                                  return AdminNICScreen(); // MENNA METHANA ERROR EKAK ENAWA..ALWAYS YANNEMA ME DEFAULT EKA WTHRI..PASSPORT ANITH EWATA GANNA AMARUI.
                              }
                            },
                          ),
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
                            alignment: Alignment.bottomCenter,
                            children: [
                              Ink.image(
                                image: AssetImage(
                                    filteredServices[index]['image']),
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.black.withOpacity(0.5),
                                child: Text(
                                  filteredServices[index]['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  scrollController.animateTo(
                    scrollController.offset + cardSize,
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 300),
                  );
                },
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
