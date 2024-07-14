import 'package:cloud_firestore/cloud_firestore.dart';

class Professor {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final List<String> modules;

  Professor(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phone,
      required this.modules});

  factory Professor.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Professor(
      uid: data['uid'] ?? '',
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      modules: List<String>.from(data['modules'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'modules': modules,
    };
  }
}
