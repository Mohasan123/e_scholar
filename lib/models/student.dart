import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String uid;
  final String name;
  final String email;
  final String codeApogee;
  final String codeMassar;
  final String adress;
  final String place;
  final String placeOfBirth;
  final DateTime dateOfBirth;
  final List<String> modules;

  Student({
    required this.uid,
    required this.name,
    required this.email,
    required this.codeApogee,
    required this.codeMassar,
    required this.adress,
    required this.place,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.modules,
  });

  factory Student.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    // Handling dateOfBirth field with different data types
    DateTime parsedDateOfBirth;
    if (data['dateOfBirth'] is Timestamp) {
      parsedDateOfBirth = (data['dateOfBirth'] as Timestamp).toDate();
    } else if (data['dateOfBirth'] is String) {
      parsedDateOfBirth = DateTime.parse(data['dateOfBirth']);
    } else {
      throw Exception("Invalid type for dateOfBirth");
    }

    return Student(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      codeApogee: data['codeApogee'] ?? '',
      codeMassar: data['codeMassar'] ?? '',
      adress: data['adress'] ?? '',
      place: data['place'] ?? '',
      placeOfBirth: data['placeOfBirth'] ?? '',
      dateOfBirth: parsedDateOfBirth,
      modules: List<String>.from(data['modules'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'codeApogee': codeApogee,
      'codeMassar': codeMassar,
      'adress': adress,
      'place': place,
      'placeOfBirth': placeOfBirth,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'modules': modules,
    };
  }
}
