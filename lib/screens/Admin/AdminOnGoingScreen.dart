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
      home: AdminOngoingScreen(),
    );
  }
}

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
          'location': docData['selectedLocation'] ?? 'No location',
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
    String returnString = '';
    switch (filter) {
      case 'Passport':
        returnString = 'PassportFormData';
        break;
      case 'Pension':
        returnString = 'PensionFormData';
        break;
      case 'License':
        returnString = 'LicenseFormData';
        break;
      case 'NIC':
        returnString = 'NICFormData';
        break;
      default:
        returnString = 'Passport';
    }
    return returnString;
  }

  void cancelAppointment(int index) {
    print("Cancelling appointment at index: $index");
    setState(() {
      filteredAppointments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width *
        0.5; // Responsive width for appointment cards
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Appointments',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 15, 110, 183),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        dropdownColor: Colors.blue,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                            filterAppointments(searchController
                                .text); // Re-filter appointments on filter change
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
                    suffixIcon: InkWell(
                      onTap: () {
                        filterAppointments(searchController.text);
                      },
                      child: const Icon(Icons.search),
                    ),
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
                      margin: const EdgeInsets.all(8),
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
