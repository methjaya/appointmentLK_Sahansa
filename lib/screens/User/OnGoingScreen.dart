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
      home: OngoingScreen(),
    );
  }
}

class OngoingScreen extends StatefulWidget {
  @override
  _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  late Future<List<Map<String, dynamic>>> dataFuture;

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
          'location': docData['location'] ?? 'No location'
        });
      }
    }

    return data;
  }

  void cancelAppointment(int index) {
    // Placeholder for cancel logic
    print("Cancelling appointment at index: $index");
    // Remove the appointment from the list
    setState(() {
      dataFuture = Future.value(List.from(dataFuture as List)..removeAt(index));
    });
    // Implement actual delete/cancel operation in your database
  }

  @override
  Widget build(BuildContext context) {
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
          Center(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView(
                    children: snapshot.data!.asMap().entries.map((entry) {
                      int idx = entry.key; // Appointment index
                      Map<String, dynamic> appointment = entry.value;
                      return Container(
                        width: MediaQuery.of(context).size.width *
                            0.8, // 80% of screen width
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Card(
                          color: Colors.white.withOpacity(0.85),
                          child: ListTile(
                            title: Text(appointment['title'],
                                style: TextStyle(
                                    color: Color.fromARGB(255, 15, 110, 183))),
                            subtitle: Text(
                                '${appointment['selectedDate']} at ${appointment['selectedTime']}\nLocation: ${appointment['location']}'),
                            leading: Icon(Icons.event_available,
                                color: Color.fromARGB(255, 15, 110, 183)),
                            trailing: IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => cancelAppointment(idx),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Text("No appointments found");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
