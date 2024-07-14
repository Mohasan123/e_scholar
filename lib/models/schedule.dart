import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String id;

  final String room;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> students; // List of student IDs
  final List<String> professors; // List of professor IDs
  final List<String> modules;

  // final List<String> groups;
  final List<String> sectors;

  Schedule({
    required this.id,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.students,
    required this.professors,
    required this.modules,
    // required this.groups,
    required this.sectors,
  });

  factory Schedule.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Schedule(
      id: data['id'],
      room: data['room'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      students: List<String>.from(data['students'] ?? ''),
      professors: List<String>.from(data['professors'] ?? ''),
      modules: List<String>.from(data['modules'] ?? ''),
      // groups: List<String>.from(data['groups'] ?? ''),
      sectors: List<String>.from(data['sectors'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room': room,
      'startTime': startTime,
      'endTime': endTime,
      'students': students,
      'professors': professors,
      'modules': modules,
      // 'groups': groups,
      'sectors': sectors,
    };
  }
}
