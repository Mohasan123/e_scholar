import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String name;
  final String room;
  final String professor;
  final String group;

  Course({
    required this.id,
    required this.name,
    required this.room,
    required this.professor,
    required this.group,
  });

  factory Course.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Course(
      id: data['id'],
      name: data['name'],
      room: data['room'],
      professor: data['professor'],
      group: data['group'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'room': room,
      'professor': professor,
      'group': group,
    };
  }
}
