import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsivetutorial/firebase_options.dart';

import 'package:responsivetutorial/screens/LicenseScreen.dart';
import 'package:responsivetutorial/screens/NICScreen.dart';
import 'package:responsivetutorial/screens/OnGoingScreen.dart';
import 'package:responsivetutorial/screens/PassportScreen.dart';
import 'package:responsivetutorial/screens/PensionScreen.dart';
import 'package:responsivetutorial/screens/LicenseInstructions.dart';
import 'package:responsivetutorial/screens/NICInstructions.dart';
import 'package:responsivetutorial/screens/PassportInstructions.dart';
import 'package:responsivetutorial/screens/PensionInstructions.dart';
import 'package:responsivetutorial/screens/UserSelectionScreen.dart';
import 'package:responsivetutorial/screens/loginScreen.dart';
import 'package:responsivetutorial/screens/welcomescreen.dart';

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
              return HomeScreen();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    InstructionSection(),
                    ServiceSection(),
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
                  left: 20), // Increase left padding for the notification icon
              child: IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OngoingScreen()),
                  );
                  // Handle notification icon press here
                },
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/officer_avatar.png'),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: 20), // Increase right padding for the logout icon
              child: IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  //Navigator.push(
                  //  context,
                  // MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  //);
                  // Handle logout icon press here
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Hi, Officer',
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

class InstructionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        'Instructions',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}

class ServiceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ServiceButton(
              label: 'NIC',
              icon: Icons.credit_card,
              instructionScreen: NICInstructions()),
          ServiceButton(
              label: 'Passport',
              icon: Icons.book,
              instructionScreen: PassportInstructions()),
          ServiceButton(
              label: 'License',
              icon: Icons.car_rental,
              instructionScreen: LicenseInstructions()),
          ServiceButton(
              label: 'Pension',
              icon: Icons.monetization_on,
              instructionScreen: PensionInstructions()),
        ],
      ),
    );
  }
}

class ServiceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget instructionScreen;

  const ServiceButton(
      {required this.label,
      required this.icon,
      required this.instructionScreen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => instructionScreen,
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 30),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white),
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
        'Make Your Appointment',
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
    double cardSize =
        screenWidth > 800 ? screenWidth * 0.25 : screenWidth * 0.4;
    double maxWidth = screenWidth * 0.8;
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                filteredServices[index]['screen'],
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

// Update the `services` list to include image paths
final List<Map<String, dynamic>> services = [
  {
    'name': 'NIC',
    'icon': Icons.credit_card,
    'screen': NICScreen(),
    'image': 'assets/nic.jpg'
  },
  {
    'name': 'Passport',
    'icon': Icons.book,
    'screen': PassportScreen(),
    'image': 'assets/passport.png'
  },
  {
    'name': 'License',
    'icon': Icons.car_rental,
    'screen': LicenseScreen(),
    'image': 'assets/license.jpg'
  },
  {
    'name': 'Pension',
    'icon': Icons.monetization_on,
    'screen': PensionScreen(),
    'image': 'assets/pension.jpg'
  },
];

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
