import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOITMENTLK_SAHANSA',
      home: HomeScreen2(),
    );
  }
}

class HomeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Booking'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentScreen()),
            );
          },
          child: Text(
            'Book Appointment',
            style: TextStyle(
              color: Color.fromARGB(255, 31, 100, 169),
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Example: Reserved time slots
  List<String> reservedTimeSlots = [
    '10:00 AM',
    '01:30 PM',
    '03:00 PM',
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date and Time'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              'Select Date',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 100, 169),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Selected Date and Time:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            _formatDateTime(selectedDate, selectedTime),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Available Time Slots:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: availableTimeSlots.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _selectTime(index);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: reservedTimeSlots
                                .contains(availableTimeSlots[index])
                            ? Colors.grey
                                .withOpacity(0.5) // Reserved slots color
                            : Color.fromARGB(255, 101, 145, 217),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          availableTimeSlots[index],
                          style: TextStyle(
                            color: reservedTimeSlots
                                    .contains(availableTimeSlots[index])
                                ? Colors.black // Reserved slots text color
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
                // Handle button click
              },
              child: Text(
                'Book Appointment',
                style: TextStyle(
                  color: Color.fromARGB(255, 31, 100, 169),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(int index) {
    if (!reservedTimeSlots.contains(availableTimeSlots[index])) {
      setState(() {
        // Update the selected time
        selectedTime = TimeOfDay(
          hour: int.parse(availableTimeSlots[index].split(':')[0]),
          minute:
              int.parse(availableTimeSlots[index].split(':')[1].split(' ')[0]),
        );
      });
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final formattedDate = "${date.day}/${date.month}/${date.year}";
    final formattedTime = "${time.format(context)}";
    return "$formattedDate $formattedTime";
  }
}
