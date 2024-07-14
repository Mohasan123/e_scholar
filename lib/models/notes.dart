import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String studentId;
  final String moduleId;
  final double practicalWork;
  final double variousWork;

  Note({
    required this.id,
    required this.studentId,
    required this.moduleId,
    required this.practicalWork,
    required this.variousWork,
  });

  factory Note.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Note(
      id: data['id'],
      studentId: data['studentId'],
      moduleId: data['moduleId'],
      practicalWork: data['practicalWork'],
      variousWork: data['variousWork'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'moduleId': moduleId,
      'practicalWork': practicalWork,
      'variousWork': variousWork,
    };
  }

  double get average => (practicalWork + variousWork) / 2;
}
