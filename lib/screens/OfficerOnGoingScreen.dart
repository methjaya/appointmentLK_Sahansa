import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOINTMENT_APP',
      home: OfficerOngoingScreen(),
    );
  }
}

class OfficerOngoingScreen extends StatefulWidget {
  @override
  _OfficerOngoingScreenState createState() => _OfficerOngoingScreenState();
}

class _OfficerOngoingScreenState extends State<OfficerOngoingScreen> {
  late Future<List<Map<String, dynamic>>> dataFuture;
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> filteredAppointments = [];
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'NIC'; // Default filter is NIC

  @override
  void initState() {
    super.initState();
    dataFuture = fetchAllData();
  }

  Future<List<Map<String, dynamic>>> fetchAllData() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_NO_USER',
        message: 'No user logged in',
      );
    }

    List<String> collections = [
      'LicenseFormData',
      'PensionFormData',
      'NICFormData',
      'PassportFormData'
    ];

    List<Future<QuerySnapshot>> futures = collections.map((collection) {
      return FirebaseFirestore.instance
          .collection(collection)
          .where('userid', isEqualTo: currentUser.uid)
          .get();
    }).toList();

    List<QuerySnapshot> snapshots = await Future.wait(futures);
    List<Map<String, dynamic>> data = [];
    for (var snapshot in snapshots) {
      for (var doc in snapshot.docs) {
        var docData = doc.data() as Map<String, dynamic>;
        data.add({
          'selectedDate': docData['selectedDate'] ?? 'No date',
          'selectedTime': docData['selectedTime'] ?? 'No time',
          'title': docData['title'] ?? 'No title',
          'location': docData['location'] ?? 'No location',
          'NIC': docData['NIC'] ?? 'No NIC',
          'phoneNumber': docData['phoneNumber'] ??
              'No phone' // Assuming phoneNumber is stored with each document for NIC
        });
      }
    }
    appointments = data;
    filteredAppointments = data;
    return data;
  }

  void filterAppointments(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> tmpList = [];
      String filterKey = selectedFilter == 'NIC' ? 'phoneNumber' : 'NIC';
      for (var appointment in appointments) {
        if ((appointment[filterKey] ?? '').contains(query)) {
          tmpList.add(appointment);
        }
      }
      setState(() {
        filteredAppointments = tmpList;
      });
    } else {
      setState(() {
        filteredAppointments = appointments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width *
        0.5; // Responsive width for search bar and dropdown

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Ongoing Appointments', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 15, 110, 183),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/nic.jpg'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue!;
                          filterAppointments(searchController
                              .text); // Re-filter based on new selection
                        });
                      },
                      items: <String>['NIC', 'Passport', 'License', 'Pension']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        (MediaQuery.of(context).size.width - width) / 2),
                child: TextField(
                  controller: searchController,
                  onChanged: filterAppointments,
                  decoration: InputDecoration(
                    labelText:
                        'Search by ${selectedFilter == 'NIC' ? 'Phone Number' : 'NIC'}',
                    suffixIcon: Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> appointment =
                        filteredAppointments[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      color: Colors.white.withOpacity(0.85),
                      child: ListTile(
                        title: Text(appointment['title'],
                            style: TextStyle(
                                color: Color.fromARGB(255, 15, 110, 183))),
                        subtitle: Text(
                            '${appointment['selectedDate']} at ${appointment['selectedTime']}\nLocation: ${appointment['location']}\nNIC: ${appointment['NIC']}\nPhone: ${appointment['phoneNumber']}'),
                        leading: Icon(Icons.event_available,
                            color: Color.fromARGB(255, 15, 110, 183)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
