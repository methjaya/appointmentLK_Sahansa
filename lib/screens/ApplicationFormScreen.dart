import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApplicationFormScreen extends StatefulWidget {
  final String selectedDistrict;
  final String selectedLocation;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String collectionName;
  final String title;

  const ApplicationFormScreen({
    Key? key,
    required this.selectedDistrict,
    required this.selectedLocation,
    required this.selectedDate,
    required this.selectedTime,
    required this.collectionName,
    required this.title,
  }) : super(key: key);

  @override
  _ApplicationFormScreenState createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute $period';
  }

  void submitToFirestore() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'nic': _nicController.text,
        'contactNumber': _contactNumberController.text,
        'email': _emailController.text,
        'dateOfBirth': dateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(dateOfBirth!)
            : null,
        'province': selectedProvince,
        'district': selectedDistrict,
        'selectedDistrict': widget.selectedDistrict,
        "selectedLocation": widget.selectedLocation,
        "selectedTime": formatTimeOfDay(widget.selectedTime),
        "selectedDate":
            DateFormat('yyyy-MM-dd').format(widget.selectedDate).toString(),
        'userid': FirebaseAuth.instance.currentUser!.uid,
        'title': widget.title,
      };

      // Reference to Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection(widget.collectionName);

      // Add data to Firestore
      users.add(formData).then((docRef) {
        print('Document successfully written with ID: ${docRef.id}');
      }).catchError((error) {
        print('Error adding document: $error');
      });
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
      appBar: AppBar(
        title: const Text('Application Form',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nicController,
                  decoration: const InputDecoration(
                    labelText: 'NIC',
                    hintText: 'Enter your NIC Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 12) {
                      return 'NIC should be exactly 12 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDateOfBirth(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: dateOfBirth == null
                            ? 'Select your date of birth'
                            : DateFormat('yyyy-MM-dd').format(dateOfBirth!),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (dateOfBirth == null) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedProvince,
                  hint: const Text('Select Province'),
                  onChanged: (value) {
                    setState(() {
                      selectedProvince = value;
                    });
                  },
                  items:
                      provinces.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a province';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  hint: const Text('Select District'),
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                    });
                  },
                  items:
                      districts.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a district';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _contactNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    hintText: 'Enter your contact number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 10) {
                      return 'Contact number should be exactly 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitToFirestore,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
