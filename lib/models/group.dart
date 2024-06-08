import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String name;

  Group({
    required this.id,
    required this.name,
  });

  factory Group.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Group(
      id: data['id'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
