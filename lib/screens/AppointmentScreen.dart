import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:AppointmentsbySahansa/screens/ApplicationFormScreen.dart';

class AppointmentScreen extends StatefulWidget {
  final String selectedDistrict;
  final String selectedLocation;
  final String collectionName;
  final String title;

  const AppointmentScreen(
      {Key? key,
      required this.selectedDistrict,
      required this.selectedLocation,
      required this.collectionName,
      required this.title})
      : super(key: key);
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<String> reservedTimeSlots = ['10:00 AM', '01:30 PM', '03:00 PM'];
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
          title: const Text('Select Date and Time'),
          backgroundColor: Colors.blue),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 30), // Added padding above the button
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date',
                  style: TextStyle(color: Color.fromARGB(255, 31, 100, 169))),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const Text('Selected Date and Time:',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text(_formatDateTime(selectedDate, selectedTime),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const SizedBox(height: 20),
                const Text('Available Time Slots:',
                    style: TextStyle(fontSize: 18)),
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
                  return InkWell(
                    onTap: () {
                      _selectTime(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: reservedTimeSlots
                                .contains(availableTimeSlots[index])
                            ? Colors.grey.withOpacity(0.5)
                            : const Color.fromARGB(255, 101, 145, 217),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          availableTimeSlots[index],
                          style: TextStyle(
                            color: reservedTimeSlots
                                    .contains(availableTimeSlots[index])
                                ? Colors.black
                                : Colors.white,
                            fontSize: 14,
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
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () {
                _showAppointmentConfirmation(context);
              },
              child: const Text('Book Appointment',
                  style: TextStyle(color: Color.fromARGB(255, 31, 100, 169))),
            ),
          ),
        ],
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
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            dialogBackgroundColor:
                Colors.white, // background color of the dialog
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedDate = value;
        });
      }
    });
  }

  void _selectTime(int index) {
    if (!reservedTimeSlots.contains(availableTimeSlots[index])) {
      setState(() {
        selectedTime = TimeOfDay(
          hour: int.parse(availableTimeSlots[index].split(':')[0]),
          minute:
              int.parse(availableTimeSlots[index].split(':')[1].split(' ')[0]),
        );
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
                  style: TextStyle(color: Color.fromARGB(255, 81, 81, 81))),
              const SizedBox(height: 10),
              Text(_formatDateTime(selectedDate, selectedTime),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0))),
              const SizedBox(height: 20),
              const Text('Click Continue to Fill Out Your Details:',
                  style: TextStyle(color: Color.fromARGB(255, 81, 81, 81))),
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
              child: const Text('Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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
              child: const Text('Continue',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            ),
          ],
        );
      },
    );
  }
}
