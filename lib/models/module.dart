import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  final String id;
  final String name;
  final String semester;
  final String moduleNum;

  Module({
    required this.id,
    required this.name,
    required this.moduleNum,
    required this.semester,
  });

  factory Module.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Module(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      moduleNum: data['moduleNum'] ?? '',
      semester: data['semester'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'moduleNum': moduleNum,
      'semester': semester,
    };
  }
}
