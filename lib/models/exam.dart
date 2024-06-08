import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  final String id;
  final String name;
  final String moduleId;
  final DateTime date;

  Exam({
    required this.id,
    required this.name,
    required this.moduleId,
    required this.date,
  });

  factory Exam.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Exam(
      id: data['id'],
      name: data['name'],
      moduleId: data['moduleId'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'moduleId': moduleId,
      'date': Timestamp.fromDate(date),
    };
  }
}
