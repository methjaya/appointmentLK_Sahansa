import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:AppointmentsbySahansa/screens/Admin/AdminHomeScreen.dart';

class AdminOngoingScreen extends StatefulWidget {
  @override
  _AdminOngoingScreenState createState() => _AdminOngoingScreenState();
}

class _AdminOngoingScreenState extends State<AdminOngoingScreen> {
  late Future<List<Map<String, dynamic>>> dataFuture;
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> filteredAppointments = [];
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'NIC'; // Default filter is NIC
  DateTime? _selectedDate;

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
          'collectionName': collections[i].replaceFirst('FormData', ''),
          'selectedDate': docData['selectedDate'] ?? 'No date',
          'selectedTime': docData['selectedTime'] ?? 'No time',
          'title': docData['title'] ?? 'No title',
          'location': docData['selectedLocation'] ?? 'No location',
          'NIC': docData['nic'] ?? 'No NIC',
          'phoneNumber': docData['contactNumber'] ?? 'No phone'
        });
      }
    }
    appointments = data;
    filteredAppointments = data;
    updateFilteredAppointments(); // Initial filter based on default selection
    return data;
  }

  void updateFilteredAppointments() {
    String query = searchController.text.toLowerCase();
    print("Selected Date: $_selectedDate");
    setState(() {
      filteredAppointments = appointments.where((appointment) {
        bool matchesFilter =
            appointment['collectionName'].toString().contains(selectedFilter);
        bool matchesSearch =
            appointment['title'].toString().toLowerCase().contains(query) ||
                appointment['NIC'].toString().toLowerCase().contains(query);
        bool matchesDate = _selectedDate == null ||
            appointment['selectedDate'] ==
                _selectedDate!.toString().split(' ')[0]; // Extract date part
        print("Appointment Date: ${appointment['selectedDate']}");
        return matchesFilter && matchesSearch && matchesDate;
      }).toList();
    });
  }

  void launchMapsUrl(String address) async {
    var url =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void cancelAppointment(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cancel Appointment"),
          content: Text("Are you sure you want to cancel this appointment?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  filteredAppointments.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      updateFilteredAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Appointments',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 15, 110, 183),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()),
            );
          },
        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: TextField(
                controller: searchController,
                onChanged: (text) => updateFilteredAppointments(),
                decoration: InputDecoration(
                  labelText: 'Search',
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    constraints: BoxConstraints(maxWidth: 600),
                    margin: EdgeInsets.all(10),
                    child: Card(
                      color: Colors.white.withOpacity(0.85),
                      child: ListTile(
                        title: Text(appointment['title'],
                            style: TextStyle(
                                color: Color.fromARGB(255, 15, 110, 183))),
                        subtitle: Text(
                            '${appointment['selectedDate']} at ${appointment['selectedTime']}\nLocation: ${appointment['location']}\nNIC: ${appointment['NIC']}'),
                        leading: Icon(Icons.event_available,
                            color: Color.fromARGB(255, 15, 110, 183)),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.map, color: Colors.green),
                              onPressed: () =>
                                  launchMapsUrl(appointment['location']),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cancelAppointment(index),
                            ),
                          ],
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
