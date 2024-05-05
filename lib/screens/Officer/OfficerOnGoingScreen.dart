import 'package:cloud_firestore/cloud_firestore.dart';
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
    List<String> collections = [
      'LicenseFormData',
      'PensionFormData',
      'NICFormData',
      'PassportFormData'
    ];

    List<Future<QuerySnapshot>> futures = collections.map((collection) {
      return FirebaseFirestore.instance.collection(collection).get();
    }).toList();

    List<QuerySnapshot> snapshots = await Future.wait(futures);
    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < snapshots.length; i++) {
      var snapshot = snapshots[i];
      for (var doc in snapshot.docs) {
        var docData = doc.data() as Map<String, dynamic>;
        data.add({
          'collectionName': collections[i],
          'selectedDate': docData['selectedDate'] ?? 'No date',
          'selectedTime': docData['selectedTime'] ?? 'No time',
          'title': docData['title'] ?? 'No title',
          'location': docData['location'] ?? 'No location',
          'NIC': docData['nic'] ?? 'No NIC',
          'phoneNumber': docData['contactNumber'] ?? 'No phone'
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
      for (var appointment in appointments.where(
        (element) =>
            element['collectionName'] == selectedFilterType(selectedFilter),
      )) {
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

  String selectedFilterType(String filter) {
    switch (filter) {
      case 'Passport':
        return 'PassportFormData';
      case 'Pension':
        return 'PensionFormData';
      case 'License':
        return 'LicenseFormData';
      case 'NIC':
        return 'NICFormData';
      default:
        return 'PassportFormData';
    }
  }

  void cancelAppointment(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors
              .white, // You can change this if you want a different background color
          title: Text("Cancel Appointment",
              style: TextStyle(color: Color.fromARGB(255, 15, 110, 183))),
          content: Text("Are you sure you want to cancel this appointment?",
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text("No",
                  style: TextStyle(color: Color.fromARGB(255, 15, 110, 183))),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes",
                  style: TextStyle(color: Color.fromARGB(255, 15, 110, 183))),
              onPressed: () {
                // Proceed with cancellation
                setState(() {
                  filteredAppointments.removeAt(index);
                  Navigator.of(context).pop(); // Close the dialog after action
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Appointments',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 15, 110, 183),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/nic.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
          ),
        ),
        child: Column(
          children: [
            DropdownButtonHideUnderline(
              child: Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width *
                        0.1), // Padding to center dropdown
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Colors.blue,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                      filterAppointments(searchController.text);
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width *
                    0.1, // Padding to center search field
              ),
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
                  return Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // Card width 80% of screen
                    constraints: BoxConstraints(
                        maxWidth: 600), // Max width for larger screens
                    margin: EdgeInsets.all(10),
                    child: Card(
                      color: Colors.white.withOpacity(0.85),
                      child: ListTile(
                        title: Text(appointment['title'],
                            style: TextStyle(
                                color: Color.fromARGB(255, 15, 110, 183))),
                        subtitle: Text(
                            '${appointment['selectedDate']} at ${appointment['selectedTime']}\nLocation: ${appointment['location']}\nNIC: ${appointment['NIC']}\nPhone: ${appointment['phoneNumber']}'),
                        leading: Icon(Icons.event_available,
                            color: Color.fromARGB(255, 15, 110, 183)),
                        trailing: IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => cancelAppointment(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
