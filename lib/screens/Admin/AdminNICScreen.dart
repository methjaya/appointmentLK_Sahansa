import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminNICScreen extends StatefulWidget {
  @override
  _AdminNICScreenState createState() => _AdminNICScreenState();
}

class _AdminNICScreenState extends State<AdminNICScreen> {
  DateTime? selectedDate;
  String searchQuery = '';
  // Mock data for the list of appointments
  final List<Map<String, dynamic>> appointments = [
    {'name': 'John Doe', 'time': '09:00 AM', 'nic': '123456789V'},
    {'name': 'Jane Smith', 'time': '10:00 AM', 'nic': '987654321V'},
    {'name': 'Alice Johnson', 'time': '11:00 AM', 'nic': '192837465V'},
    {'name': 'Bob Brown', 'time': '12:00 PM', 'nic': '564738291V'},
    {'name': 'Charlie Davis', 'time': '01:00 PM', 'nic': '918273645V'},
    {'name': 'Dana White', 'time': '02:00 PM', 'nic': '827364558V'}
  ];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  List<Map<String, dynamic>> get filteredAppointments {
    return searchQuery.isEmpty
        ? appointments
        : appointments.where((appointment) {
            return appointment['nic']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment, int index) {
    return Card(
      color: Colors.blueGrey[100],
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.person, size: 40),
        title: Text(appointment['name']),
        subtitle: Text("NIC: ${appointment['nic']}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appointment['time'],
              style: TextStyle(
                  color:
                      Colors.blue[800], // Highlight the time with a theme color
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                (index + 1).toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NIC Appointments'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Appointments for ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _handleSearch,
              decoration: InputDecoration(
                labelText: 'Search by NIC',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(
                    filteredAppointments[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
