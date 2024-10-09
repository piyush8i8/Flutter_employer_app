import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String _name = '';
  String _employeeType = '';
  String _gender = '';
  String _contact = '';
  String _email = '';

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _employeeType = prefs.getString('employeeType') ?? '';
      _gender = prefs.getString('gender') ?? '';
      _contact = prefs.getString('contact') ?? '';
      _email = prefs.getString('email') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trainer Details',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: $_name', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Employee Type: $_employeeType', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Gender: $_gender', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Contact: $_contact', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: $_email', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
