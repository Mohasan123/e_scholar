import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:e_scolar_app/models/userdata.dart';
import 'package:flutter/material.dart';

import '../auth/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  Student? _student;

  final AuthMethods _authMethods = AuthMethods();

  UserData? get getUser => _user;

  Student? get getStudent => _student;

  Future<void> refreshUser() async {
    UserData user = await _authMethods.getUserDetails();
    _user = user;
    _student = await getStudentForLoggedInUser(user.uid);
    notifyListeners();
  }

  Future<Student?> getStudentForLoggedInUser(String uid) async {
    final snapshotStud = await FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: uid)
        .get();

    if (snapshotStud.docs.isNotEmpty) {
      return Student.fromSnapshot(snapshotStud.docs.first);
    } else {
      return null;
    }
  }
}
