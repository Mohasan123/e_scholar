import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String id;
  final String studentName;
  final String codeApogee;
  final String documentType;
  final DateTime requestedAt;

  Request({
    required this.id,
    required this.studentName,
    required this.codeApogee,
    required this.documentType,
    required this.requestedAt,
  });

  factory Request.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Request(
      id: snapshot.id,
      studentName: data['studentName'] ?? '',
      codeApogee: data['codeApogee'] ?? '',
      documentType: data['documentType'] ?? '',
      requestedAt: (data['requestedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentName': studentName,
      'codeApogee': codeApogee,
      'documentType': documentType,
      'requestedAt': requestedAt,
    };
  }
}
