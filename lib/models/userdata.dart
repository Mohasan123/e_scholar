import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, admin }

class UserData {
  final String uid;
  final String email;
  final String phone;
  final UserRole role;

  UserData({
    required this.email,
    required this.uid,
    required this.phone,
    required this.role,
  });

  factory UserData.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserData(
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      phone: snapshot['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == "UserRole." + (snapshot['role'] ?? 'student'),
        orElse: () => UserRole.student,
      ),
    );
  }

// factory UserData.fromJson(Map<String, dynamic> json) {
//   return UserData(
//     email: json['email'],
//     name: json['username'],
//     uid: json['uid'],
//     role: UserRole.values.firstWhere(
//       (element) => element.toString() == json['role'],
//       orElse: () => UserRole.student,
//     ),
//   );
// }

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "phone": phone,
        "role": role.toString().split('.').last,
      };

// static UserData fromSnap(DocumentSnapshot snap) {
//   var snapshot = snap.data() as Map<String, dynamic>;
//   return UserData(
//     email: snapshot['email'],
//     name: snapshot['username'],
//     uid: snapshot['uid'],
//     role: UserRole.values.firstWhere(
//       (element) => element.toString() == snapshot['role'],
//       orElse: () => UserRole.student,
//     ),
//   );
// }
}
