import 'package:cloud_firestore/cloud_firestore.dart';

class Sector {
  final String id;
  final String name;

  final String groups; // List of group IDs
  final List<String> students; // List of student IDs
  final List<String> professors; // List of professor IDs
  final List<String> modules; // List of professor IDs

  Sector({
    required this.id,
    required this.name,
    required this.groups,
    required this.students,
    required this.professors,
    required this.modules,
  });

  factory Sector.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Sector(
      id: data['id'],
      name: data['name'],
      groups: data['groups'],
      students: List<String>.from(data['students'] ?? ''),
      professors: List<String>.from(data['professors'] ?? ''),
      modules: List<String>.from(data['modules'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groups': groups,
      'students': students,
      'professors': professors,
      'modules': modules,
    };
  }
}
