import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Slot Selector',
      theme: ThemeData(
        primaryColor: Colors.blue, // Set primary color to blue
        primarySwatch: Colors.blue, // Set primary swatch to blue
      ),
      home: TimeSlotSelector(),
    );
  }
}

class TimeSlotSelector extends StatefulWidget {
  @override
  _TimeSlotSelectorState createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  DateTime? _selectedDate; // Changed type to DateTime?
  TimeOfDay? _selectedTime; // Changed type to TimeOfDay?
  bool _showDateTime = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(String time) {
    // Extract hour and minute from time string
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1].split(' ')[0]);

    setState(() {
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    });

    if (!_showDateTime) {
      _showDateTime = true;
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext? context, Widget? child) {
        return theme.useMaterial3
            ? MediaQuery(
                data: MediaQuery.of(context!)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!,
              )
            : child!;
      },
    );
    if (picked != null) print({picked.toString()});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2015, 8),
    lastDate: DateTime(2101),
  );
  if (picked != null) print({picked.toString()});
}
