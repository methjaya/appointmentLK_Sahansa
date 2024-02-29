import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOINTMENT_APP',
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
        backgroundColor: Colors.blue,
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
              primaryColor: Colors.blue,
              textTheme: CupertinoTextThemeData(
                pickerTextStyle: TextStyle(
                  color: Colors.black,
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
            'Selection Completed',
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
              SizedBox(height: 20),
              Text(
                'Click Continue to Fill Out Your Details:',
                style: TextStyle(color: const Color.fromARGB(255, 81, 81, 81)),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 116, 116, 116),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplicationFormScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Continue',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ApplicationFormScreen extends StatefulWidget {
  @override
  _ApplicationFormScreenState createState() => _ApplicationFormScreenState();
}

void _showSubmitConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Submission Successful',
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
              'Your form submission was successful.',
              style: TextStyle(color: const Color.fromARGB(255, 81, 81, 81)),
            ),
            SizedBox(height: 10),
            Text(
              'Booking ID: 45623', // Replace with the actual booking ID
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 81, 81, 81),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Click Continue to fill out your details:',
              style: TextStyle(color: const Color.fromARGB(255, 81, 81, 81)),
            ),
            SizedBox(height: 10),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Close both popups
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 116, 116, 116),
            ),
            child: Text(
              'OK',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Any additional action needed on Continue
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              'Continue',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ],
      );
    },
  );
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Form'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(label: 'First Name', index: 1, icon: Icons.person),
              SizedBox(height: 16),
              buildTextField(label: 'Last Name', index: 2, icon: Icons.person),
              SizedBox(height: 16),
              buildTextField(
                  label: 'NIC Number', index: 3, icon: Icons.credit_card),
              SizedBox(height: 16),
              buildDateField(
                  label: 'Date of Birth', index: 4, icon: Icons.calendar_today),
              SizedBox(height: 16),
              buildTextField(
                  label: 'Province',
                  index: 5,
                  icon: Icons.location_city,
                  isDropdown: true),
              SizedBox(height: 16),
              buildTextField(
                  label: 'District',
                  index: 6,
                  icon: Icons.location_city,
                  isDropdown: true),
              SizedBox(height: 16),
              buildTextField(
                  label: 'Contact Number', index: 7, icon: Icons.phone),
              SizedBox(height: 16),
              buildTextField(label: 'Email', index: 8, icon: Icons.email),
              // Add more fields as needed
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _showSubmitConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Color.fromARGB(255, 15, 110, 183), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Submit'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Color.fromARGB(255, 31, 100, 169), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {required String label,
      required int index,
      required IconData icon,
      bool isDropdown = false}) {
    return isDropdown
        ? buildDropdownField(label: label, index: index, icon: icon)
        : TextFormField(
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Enter $label',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(icon),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              return null;
            },
          );
  }

  Widget buildDropdownField(
      {required String label, required int index, required IconData icon}) {
    List<String> items = label == 'Province'
        ? [
            'Central',
            'Eastern',
            'North Central',
            'Northern',
            'North Western',
            'Sabaragamuwa',
            'Southern',
            'Uva',
            'Western'
          ]
        : [
            'Ampara',
            'Anuradhapura',
            'Badulla',
            'Batticaloa',
            'Colombo',
            'Galle',
            'Gampaha',
            'Hambantota',
            'Jaffna',
            'Kalutara',
            'Kandy',
            'Kegalle',
            'Kilinochchi',
            'Kurunegala',
            'Mannar',
            'Matale',
            'Matara',
            'Monaragala',
            'Mullaitivu',
            'Nuwara Eliya',
            'Polonnaruwa',
            'Puttalam',
            'Ratnapura',
            'Trincomalee'
          ];

    String? selectedValue;

    return DropdownButtonFormField<String>(
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedValue = value;
        });
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select $label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget buildDateField(
      {required String label, required int index, required IconData icon}) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select $label',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(icon),
        ),
        child: Text(
          _formatDate(selectedDate),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = selectedDate;

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: Colors.white,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue,
              textTheme: CupertinoTextThemeData(
                pickerTextStyle: TextStyle(
                  color: Colors.black,
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
