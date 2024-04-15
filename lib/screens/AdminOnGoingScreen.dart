import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOINTMENT_APP',
      home: AdminOngoingScreen(),
    );
  }
}

class AdminOngoingScreen extends StatefulWidget {
  @override
  _AdminOngoingScreenState createState() => _AdminOngoingScreenState();
}

class _AdminOngoingScreenState extends State<AdminOngoingScreen> {
  List<Map<String, String>> appointments = [
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
          // Centered cards with adjusted width
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: appointments
                    .map((appointment) => Container(
                          key: ValueKey(appointment),
                          width: MediaQuery.of(context).size.width *
                              0.8, // 80% of screen width
                          child: Card(
                            color: Colors.white.withOpacity(0.85),
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(appointment['description']!,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 15, 110, 183))),
                              subtitle: Text(
                                  '${appointment['date']} at ${appointment['time']}'),
                              leading: Icon(Icons.event_available,
                                  color: Color.fromARGB(255, 15, 110, 183)),
                              trailing: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _showCancelConfirmation(
                                    context, appointment),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
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
                _removeAppointment(appointment);
              },
            ),
          ],
        );
      },
    );
  }

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
  }
}
