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
  /*List<Map<String, String>> appointments = [
    {
      'time': '09:00 AM',
      'date': '2024-04-15',
      'description': 'Appointment NIC'
    },
    {
      'time': '11:00 AM',
      'date': '2024-04-15',
      'description': 'Appointment PASSPORT'
    },
    {
      'time': '02:00 PM',
      'date': '2024-04-16',
      'description': 'Appointment LICENSE' 
    },
  ];
*/
  late Future<List<Map<String, dynamic>>> dataFuture;

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
      return FirebaseFirestore.instance
          .collection(collection)
          .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
    }).toList();

    List<QuerySnapshot> snapshots = await Future.wait(futures);
    List<Map<String, dynamic>> data = [];
    for (var snapshot in snapshots) {
      for (var doc in snapshot.docs) {
        var docData = doc.data() as Map<String, dynamic>;
        // Extract only the necessary fields
        data.add({
          'selectedDate': docData['selectedDate'],
          'selectedTime': docData['selectedTime'],
          'title': docData['title'],
        });
      }
    }

    print(data);
    return data;
  }

  Map<String, String>? lastRemovedAppointment;
  int? lastRemovedIndex;

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
          // Background image with gradient
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
          // FutureBuilder for dynamic data fetching
          Center(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAllData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: snapshot.data!
                          .map((appointment) => Container(
                                key: ValueKey(appointment['description']),
                                width: MediaQuery.of(context).size.width *
                                    0.8, // 80% of screen width
                                child: Card(
                                  color: Colors.white.withOpacity(0.85),
                                  margin: EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(appointment['description'],
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 15, 110, 183))),
                                    subtitle: Text(
                                        '${appointment['date']} at ${appointment['time']}'),
                                    leading: Icon(Icons.event_available,
                                        color:
                                            Color.fromARGB(255, 15, 110, 183)),
                                    trailing: IconButton(
                                      icon:
                                          Icon(Icons.cancel, color: Colors.red),
                                      onPressed: () {
                                        // Implementation for canceling the appointment
                                      },
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
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

  void _showCancelConfirmation(
      BuildContext context, Map<String, String> appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment',
              style: TextStyle(color: Color.fromARGB(255, 15, 110, 183))),
          content: Text('Are you sure you want to cancel this appointment?',
              style: TextStyle(color: Color.fromARGB(255, 15, 110, 183))),
          actions: <Widget>[
            TextButton(
              child: Text('No',
                  style: TextStyle(color: Color.fromARGB(255, 15, 110, 183))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Yes',
                  style: TextStyle(color: Color.fromARGB(255, 15, 110, 183))),
              onPressed: () {
                Navigator.of(context).pop();
                // _removeAppointment(appointment);
              },
            ),
          ],
        );
      },
    );
  }
/*
  void _removeAppointment(Map<String, String> appointment) {
    setState(() {
      lastRemovedIndex = appointments.indexOf(appointment);
      lastRemovedAppointment = appointment;
      appointments.remove(appointment);
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Appointment cancelled'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () => _undoRemoval(),
          ),
        ));
    });
  }

  void _undoRemoval() {
    if (lastRemovedAppointment != null && lastRemovedIndex != null) {
      setState(() {
        appointments.insert(lastRemovedIndex!, lastRemovedAppointment!);
      });
    }
  }*/
}
