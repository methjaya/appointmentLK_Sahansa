import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOITMENTLK_SAHANSA',
      home: ddNIC(),
    );
  }
}

class ddNIC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment for NIC',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 15, 110, 183),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/mying1.jpg'),
                      fit: BoxFit.cover,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentScreen(),
                        ),
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
              ],
            ),
          ),
        ],
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
        backgroundColor: Colors.blue, // Set the background color to blue
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
                            ? Colors.grey.withOpacity(0.5)
                            : Color.fromARGB(255, 101, 145, 217),
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
    DateTime? pickedDate;

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: Colors.white,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue, // Set the primary color to blue
              textTheme: CupertinoTextThemeData(
                pickerTextStyle: TextStyle(
                  color: Colors.black, // Set the text color to black
                ),
              ),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                pickedDate = newDate;
              },
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate!;
      });
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
      });
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final formattedDate = "${date.day}/${date.month}/${date.year}";
    final formattedTime = "${time.format(context)}";
    return "$formattedDate $formattedTime";
  }

  void _showAppointmentConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Appointment Completed',
            style: TextStyle(color: Colors.blue),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                'Your appointment is completed for:',
                style: TextStyle(color: const Color.fromARGB(255, 81, 81, 81)),
              ),
              SizedBox(height: 10),
              Text(
                _formatDateTime(selectedDate, selectedTime),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 116, 116, 116),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        );
      },
    );
  }
}
