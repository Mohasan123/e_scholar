import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  final String id;
  final String studentId;
  final String message;
  final DateTime timestamp;

  Notifications({
    required this.id,
    required this.studentId,
    required this.message,
    required this.timestamp,
  });

  factory Notifications.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    // Enhanced debug logging
    print('Snapshot Data: $data');

    // Check if the fields exist and have the expected types
    if (data.containsKey('studentId') &&
        data['studentId'] is String &&
        data.containsKey('message') &&
        data['message'] is String &&
        data.containsKey('timestamp') &&
        data['timestamp'] is Timestamp) {
      return Notifications(
        id: snapshot.id,
        studentId: data['studentId'] ?? '',
        message: data['message'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );
    } else {
      // Handle the error gracefully if the fields are missing or have wrong types
      print('Error: Missing or incorrect data types in snapshot: $data');
      return Notifications(
        id: snapshot.id,
        studentId: '',
        message: '',
        timestamp: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
