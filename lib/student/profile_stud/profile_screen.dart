import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileStudent extends StatefulWidget {
  const ProfileStudent({super.key});

  @override
  State<ProfileStudent> createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {
  late Student? _student;
  bool _isLoading = true;
  List<String> _moduleNames = [];

  @override
  void initState() {
    super.initState();
    _loadStudentProfile();
  }

  Future<void> _loadStudentProfile() async {
    AuthMethods authMethods = AuthMethods();
    Student? student = await authMethods.getCurrentStudent();
    if (student != null) {
      List<String> moduleNames = await _getModuleNames(student.modules);
      setState(() {
        _student = student;
        _moduleNames = moduleNames;
        _isLoading = false;
      });
    } else {
      setState(() {
        _student = null;
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _getModuleNames(List<String> moduleIds) async {
    List<String> moduleNames = [];
    for (String id in moduleIds) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('modules').doc(id).get();
      if (snapshot.exists) {
        moduleNames.add(snapshot['name'] ?? id);
      } else {
        moduleNames.add(id);
      }
    }
    return moduleNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _student == null
              ? const Center(child: Text('No student data found.'))
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(''),
                          // Placeholder image URL
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          _student!.name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _student!.email,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildProfileDetail(
                            'Code Apogee', _student!.codeApogee),
                        _buildProfileDetail(
                            'Code Massar', _student!.codeMassar),
                        _buildProfileDetail('Address', _student!.adress),
                        _buildProfileDetail('Place', _student!.place),
                        _buildProfileDetail(
                            'Place of Birth', _student!.placeOfBirth),
                        _buildProfileDetail(
                            'Date of Birth',
                            DateFormat('yyyy-MM-dd')
                                .format(_student!.dateOfBirth)),
                        _buildProfileDetail('Modules', _moduleNames.join(', ')),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
