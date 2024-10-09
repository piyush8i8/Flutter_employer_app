import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Model.dart'; // Import the model

class ViewRecordsScreen extends StatefulWidget {
  @override
  _ViewRecordsScreenState createState() => _ViewRecordsScreenState();
}

class _ViewRecordsScreenState extends State<ViewRecordsScreen> {
  List<Record> _records = []; // Changed to a List of Record
  String? _selectedTrainer;
  Record? _selectedRecord;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/records'), // Replace with your GET URL
      );

      if (response.statusCode == 200) {
        // Parse the JSON response into List of Records
        final List<dynamic> recordsJson = jsonDecode(response.body);
        setState(() {
          _records = recordsJson.map((json) => Record.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to fetch records: ${response.body}');
      }
    } catch (error) {
      print('Error fetching records: $error');
    }
  }

  void _onTrainerSelected(String? trainerName) {
    setState(() {
      _selectedTrainer = trainerName;
      _selectedRecord = _records.firstWhere(
            (record) => record.name == _selectedTrainer,
      //  orElse: () => null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Records'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _selectedTrainer,
                hint: Text('Select Trainer'),
                onChanged: _onTrainerSelected,
                dropdownColor: Colors.purple[50],
                style: TextStyle(
                  color: Colors.purple[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                underline: SizedBox(),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.purple[800]),
                items: _records.map<DropdownMenuItem<String>>((record) {
                  return DropdownMenuItem<String>(
                    value: record.name,
                    child: Text(record.name),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            _selectedRecord != null
                ? Expanded(
              child: Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            _selectedRecord!.name,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Divider(color: Colors.purple[200]),
                        _buildInfoRow('Employee Type:', _selectedRecord!.employeeType),
                        _buildInfoRow('Gender:', _selectedRecord!.gender),
                        _buildInfoRow('Contact:', _selectedRecord!.contact),
                        _buildInfoRow('Email:', _selectedRecord!.email),
                        SizedBox(height: 20),
                        Divider(color: Colors.grey[400]),
                        SizedBox(height: 10),
                        Text(
                          'Subject Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        _selectedRecord!.subjectData.isNotEmpty
                            ? _buildSubjectTable(_selectedRecord!.subjectData)
                            : Text(
                          'No subject data available',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                : Center(
              child: Text(
                'Select a trainer to view details',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTable(Map<String, dynamic> subjectData) {
    return Table(
      border: TableBorder.all(color: Colors.purple, width: 1.5),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.purple.withOpacity(0.2)),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Subject',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '0-40%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '40-80%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '80-100%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        ...subjectData.entries.map((subjectEntry) {
          Map<String, dynamic> subjectValues = subjectEntry.value as Map<String, dynamic>;
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subjectEntry.key,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subjectValues['0-40%'].toString(),
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subjectValues['40-80%'].toString(),
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subjectValues['80-100%'].toString(),
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
