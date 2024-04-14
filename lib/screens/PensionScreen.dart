import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APPOINTMENT_APP',
      home: PensionScreen(),
    );
  }
}

class PensionScreen extends StatefulWidget {
  @override
  _PensionScreenState createState() => _PensionScreenState();
}

class _PensionScreenState extends State<PensionScreen> {
  final List<String> districts = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Moneragala',
    'Ratnapura',
    'Kegalle'
  ];

  String? selectedDistrict;
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    double dropdownWidth = MediaQuery.of(context).size.width *
        0.5; // Set the width of the dropdown

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment for Pension',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 15, 110, 183),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pension.jpg'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
          // Centered content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:
                        dropdownWidth, // Use the calculated width for the dropdown
                    child: DropdownButtonFormField<String>(
                      value: selectedDistrict,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDistrict = newValue;
                          selectedLocation =
                              null; // Reset location on district change
                        });
                      },
                      items: districts
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Your Nearest District',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color.fromARGB(255, 15, 110, 183),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Color.fromARGB(255, 15, 110, 183),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (selectedDistrict != null)
                    ...[
                      '$selectedDistrict Sectarian\'s Office',
                      '$selectedDistrict Divisional Office'
                    ]
                        .map(
                          (location) => Container(
                            width:
                                dropdownWidth, // Set the width to match the dropdown
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // White background for location cards
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(location,
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 15, 110, 183))),
                              selected: selectedLocation == location,
                              onTap: () {
                                setState(() {
                                  selectedLocation = location;
                                });
                              },
                              leading: Radio<String>(
                                value: location,
                                groupValue: selectedLocation,
                                onChanged: (value) {
                                  setState(() {
                                    selectedLocation = value;
                                  });
                                },
                                activeColor: Color.fromARGB(255, 15, 110, 183),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedLocation != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentScreen()),
                            );
                          }
                        : null,
                    child: Text('Book Appointment',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 15, 110, 183),
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor:
                          Colors.grey.withOpacity(0.12), // Color when disabled
                    ),
                  ),
                ],
              ),
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
          title: Text('Select Date and Time'), backgroundColor: Colors.blue),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 30), // Added padding above the button
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date',
                  style: TextStyle(color: Color.fromARGB(255, 31, 100, 169))),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text('Selected Date and Time:', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text(_formatDateTime(selectedDate, selectedTime),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                SizedBox(height: 20),
                Text('Available Time Slots:', style: TextStyle(fontSize: 18)),
                SizedBox(height: 30),
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
              child: Text('Book Appointment',
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
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
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
          title:
              Text('Selection Completed', style: TextStyle(color: Colors.blue)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 40),
              SizedBox(height: 10),
              Text('Your appointment is completed for:',
                  style:
                      TextStyle(color: const Color.fromARGB(255, 81, 81, 81))),
              SizedBox(height: 10),
              Text(_formatDateTime(selectedDate, selectedTime),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0))),
              SizedBox(height: 20),
              Text('Click Continue to Fill Out Your Details:',
                  style:
                      TextStyle(color: const Color.fromARGB(255, 81, 81, 81))),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 116, 116, 116)),
              child: Text('Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApplicationFormScreen()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Continue',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  DateTime? dateOfBirth;
  String? selectedProvince;
  String? selectedDistrict;
  final List<String> provinces = [
    'Central',
    'Eastern',
    'Northern',
    'Southern',
    'Western',
    'North Western',
    'North Central',
    'Uva',
    'Sabaragamuwa'
  ];
  final List<String> districts = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Moneragala',
    'Ratnapura',
    'Kegalle'
  ];

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
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
    );
    if (picked != null && picked != dateOfBirth) {
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Application Form'), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'NIC',
                  hintText: 'Enter your NIC Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDateOfBirth(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      hintText: dateOfBirth == null
                          ? 'Select your date of birth'
                          : DateFormat('yyyy-MM-dd').format(dateOfBirth!),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedProvince,
                hint: Text('Select Province'),
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value;
                  });
                },
                items: provinces.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedDistrict,
                hint: Text('Select District'),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
                items: districts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  hintText: 'Enter your contact number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Submit form data function
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Colors.blue, // This will set the text color to white
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
