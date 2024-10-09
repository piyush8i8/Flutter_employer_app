// lib/record_model.dart

class Record {
  final String name;
  final String employeeType;
  final String gender;
  final String contact;
  final String email;
  final Map<String, dynamic> subjectData;

  Record({
    required this.name,
    required this.employeeType,
    required this.gender,
    required this.contact,
    required this.email,
    required this.subjectData,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      name: json['name'],
      employeeType: json['employeeType'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      contact: json['contact'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      subjectData: json['subjectData'] ?? {},
    );
  }
}
