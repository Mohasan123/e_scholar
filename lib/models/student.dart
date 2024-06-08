import 'package:cloud_firestore/cloud_firestore.dart';


enum Group {group1, group2}
class Student {
  final String uid;
  final String name;
  final String email;
  final List<String> modules;

  Student({
    required this.uid,
    required this.name,
    required this.email,
    required this.modules,
  });

  factory Student.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Student(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      modules: List<String>.from(data['modules']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'modules': modules,
    };
  }
}
