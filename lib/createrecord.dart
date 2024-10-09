import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:testass/main-screen.dart'; // Required for jsonEncode

class CreateScreenRecord extends StatefulWidget {
  @override
  _CreateScreenRecordState createState() => _CreateScreenRecordState();
}

class _CreateScreenRecordState extends State<CreateScreenRecord> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _employeeType = 'Regular'; // Default value for dropdown
  String _gender = 'Male'; // Default value for gender dropdown
  String _contact = '';
  String _email = '';

  // Subject marks and student count by percentage range
  Map<String, Map<String, String>> _subjectData = {
    'Hindi': {'0-40%': '', '40-80%': '', '80-100%': ''},
    'English': {'0-40%': '', '40-80%': '', '80-100%': ''},
    'Math': {'0-40%': '', '40-80%': '', '80-100%': ''},
    'Computer Science': {'0-40%': '', '40-80%': '', '80-100%': ''},
  };

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the data to be sent to the server
      final Map<String, dynamic> data = {
        'name': _name,
        'employeeType': _employeeType,
        'gender': _gender,
        'contact': _contact,
        'email': _email,
        'subjectData': _subjectData,
      };

      // Convert the data to JSON
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/records'), // Update with your server's URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
      }

      // Check for successful response
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Record Created')),
        );

        // Optionally clear the form after submission
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create record: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employment Form'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Header
                    Text(
                      'Trainers Details',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Name Input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.purple.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purple.shade700),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Employee Type Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Employee Type',
                        labelStyle: TextStyle(color: Colors.purple.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _employeeType,
                      items: ['Regular', 'Adhoc']
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _employeeType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(color: Colors.purple.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _gender,
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Contact Input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        labelStyle: TextStyle(color: Colors.purple.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purple.shade700),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          _contact = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Email Input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.purple.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purple.shade700),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    // Subject Details Header
                    Text(
                      'Subject Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Input fields for each subject and percentage ranges
                    ..._subjectData.entries.map((entry) {
                      String subject = entry.key;
                      Map<String, String> ranges = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...ranges.entries.map((rangeEntry) {
                            String range = rangeEntry.key;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: '$range (Number of Students)',
                                  labelStyle: TextStyle(color: Colors.purple.shade600),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.purple.shade700),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _subjectData[subject]![range] = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 20),
                        ],
                      );
                    }).toList(),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          backgroundColor: Colors.purple.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
