import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AppointmentsbySahansa/screens/ApplicationFormScreen.dart';

class AppointmentScreen extends StatefulWidget {
  final String selectedDistrict;
  final String selectedLocation;
  final String collectionName;
  final String title;

  const AppointmentScreen({
    Key? key,
    required this.selectedDistrict,
    required this.selectedLocation,
    required this.collectionName,
    required this.title,
  }) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int? selectedIndex; // Track the index of the selected time slot
  List<String> reservedTimeSlots = [];
  List<String> availableTimeSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
  ];
  List<String> isSpecialReserved = [];

  @override
  void initState() {
    super.initState();
    _fetchReservedTimeSlots(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    int crossAxisCount = screenSize.width > 1200
        ? 6
        : screenSize.width > 800
            ? 4
            : 2;
    double aspectRatio = screenSize.width > 800 ? 4 : 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Date and Time',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 123, 217),
        leading: selectedIndex == null
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      body: Container(
        color: Colors.blue[800],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ), // Added padding above the button
              child: ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select Date',
                    style: TextStyle(color: Colors.blue)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Text('Selected Date and Time:',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(
                    _formatDateTime(selectedDate, selectedTime),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text('Available Time Slots:',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255))),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: aspectRatio / 1,
                  ),
                  itemCount: availableTimeSlots.length,
                  itemBuilder: (context, index) {
                    final isReserved =
                        reservedTimeSlots.contains(availableTimeSlots[index]);
                    final isActive = selectedIndex == index && !isReserved;
                    final isSpecialReserved =
                        availableTimeSlots[index] == '11:30 AM' ||
                            availableTimeSlots[index] == '01:00 PM';

                    return isSpecialReserved
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                availableTimeSlots[index],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              if (!isReserved) _selectTime(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isReserved
                                    ? Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.5)
                                    : isActive
                                        ? Color.fromARGB(255, 176, 221, 255)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  availableTimeSlots[index],
                                  style: TextStyle(
                                    color: isReserved
                                        ? Colors.black
                                        : isActive
                                            ? Colors.white
                                            : Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showAppointmentConfirmation(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 5,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Book Appointments',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate;
    await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedDate = value;
          _fetchReservedTimeSlots(selectedDate);

          // Print selected date
          print(
              'Selected date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
        });
      }
    });
  }

  Future<void> _fetchReservedTimeSlots(DateTime selectedDate) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('NICFormData')
          .where('selectedDate', isEqualTo: selectedDate)
          .where('selectedLocation', isEqualTo: widget.selectedLocation)
          .get();

      bool existingAppointments = querySnapshot.docs.isNotEmpty;

      if (existingAppointments) {
        // Print existing appointments' reserved time slots from Firebase
        List<String> reservedTimeSlots = [];
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String reservedTime =
              doc['selectedTime']; // Assuming the field name is 'selectedTime'
          reservedTimeSlots.add(reservedTime);
        }
        print('Reserved Time Slots from Firebase: $reservedTimeSlots');
      }

      if (!existingAppointments) {
        // If no appointments found with the specific date and location,
        // iterate through all documents in the collection
        QuerySnapshot allDocsSnapshot =
            await FirebaseFirestore.instance.collection('NICFormData').get();

        for (QueryDocumentSnapshot doc in allDocsSnapshot.docs) {
          dynamic selectedDateField = doc['selectedDate'];

          // Check if selectedDateField is a Timestamp
          if (selectedDateField is Timestamp) {
            DateTime date = selectedDateField.toDate();
            // Compare dates without considering the time component
            if (date.year == selectedDate.year &&
                date.month == selectedDate.month &&
                date.day == selectedDate.day &&
                doc['selectedLocation'] == widget.selectedLocation) {
              existingAppointments = true;
              break;
            }
          } else if (selectedDateField is String) {
            // Convert String to DateTime
            DateTime date = DateTime.parse(selectedDateField);
            // Compare dates without considering the time component
            if (date.year == selectedDate.year &&
                date.month == selectedDate.month &&
                date.day == selectedDate.day &&
                doc['selectedLocation'] == widget.selectedLocation) {
              existingAppointments = true;
              break;
            }
          }
        }
      }

      setState(() {
        // Update UI based on reserved time slots
        selectedIndex = null;
        print('Existing Appointments: $existingAppointments');
      });
    } catch (e) {
      print('Error fetching reserved time slots: $e');
    }
  }

  void _selectTime(int index) {
    if (!reservedTimeSlots.contains(availableTimeSlots[index])) {
      setState(() {
        selectedTime = TimeOfDay(
          hour: int.parse(availableTimeSlots[index].split(':')[0]),
          minute:
              int.parse(availableTimeSlots[index].split(':')[1].split(' ')[0]),
        );
        selectedIndex = index;
      });
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    return "${DateFormat('yyyy-MM-dd').format(date)} ${time.format(context)}";
  }

  void _showAppointmentConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selection Completed',
              style: TextStyle(color: Colors.blue)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 40),
              const SizedBox(height: 10),
              const Text('Your appointment is completed for:',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 10),
              Text(
                _formatDateTime(selectedDate, selectedTime),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text('Click Continue to Fill Out Your Details:',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 116, 116, 116)),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplicationFormScreen(
                      selectedDistrict: widget.selectedDistrict,
                      selectedLocation: widget.selectedLocation,
                      selectedDate: selectedDate,
                      selectedTime: selectedTime,
                      collectionName: widget.collectionName,
                      title: widget.title,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child:
                  const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
