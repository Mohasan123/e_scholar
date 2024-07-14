import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/models/notes.dart';
import 'package:e_scolar_app/models/notification.dart';
import 'package:e_scolar_app/models/professor.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:e_scolar_app/models/userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../models/group.dart';
import '../models/module.dart';
import '../models/schedule.dart';
import '../models/sector.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final authBioMetrics = LocalAuthentication();

  FirebaseFirestore get fireStore => _fireStore;

/*
* 1 - student => Num Apogee (rundm 42512) + model ( name + filier)
* */
  /*  ======= register Users (Student) ====== */

  Future<String> registerUser({
    required String email,
    required String name,
    required String password,
    required String phone,
    required String? codeMassar,
    required String adress,
    required String place,
    required String placeOfBirth,
    required DateTime dateOfBirth,
    required UserRole role,
    required List<String> modules,
    String? codeApogee,
  }) async {
    String result = "Some Error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (cred.user != null) {
          String uid = cred.user!.uid;
          if (role == UserRole.student) {
            if (codeApogee == null) {
              throw Exception("Code Apogee is For Student Registration");
            }
            Student student = Student(
              uid: uid,
              name: name,
              email: email,
              codeApogee: codeApogee,
              modules: modules,
              codeMassar: codeMassar!,
              adress: adress,
              place: place,
              placeOfBirth: placeOfBirth,
              dateOfBirth: dateOfBirth,
            );
            await _fireStore
                .collection('students')
                .doc(uid)
                .set(student.toMap());
          } else if (role == UserRole.professor) {
            Professor professor = Professor(
                uid: uid,
                name: name,
                email: email,
                phone: phone,
                modules: modules);
            await _fireStore
                .collection('professors')
                .doc(uid)
                .set(professor.toMap());
          }
          UserData userData = UserData(
            email: email,
            uid: uid,
            phone: phone,
            role: role,
          );
          await _fireStore.collection('users').doc(uid).set(
                userData.toJson(),
              );
        }
        result = "success";
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  } //Register user

  /*  ======= Email Multi-Factor Authentication ====== */
  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  Future<bool> verifyEmail(User user) async {
    await user.reload();
    return user.emailVerified;
  }

  /*  ==== Biometrics Verification ===== */
  static Future<bool> canAuthenticate() async {
    bool canAuthenticateWithBiometrics =
        await authBioMetrics.canCheckBiometrics;
    bool canAuthenticateWithPasscode = await authBioMetrics.isDeviceSupported();
    return canAuthenticateWithBiometrics || canAuthenticateWithPasscode;
  }

  static Future<bool> authenticate() async {
    try {
      return await authBioMetrics.authenticate(
        localizedReason: 'Please authenticate to show account',
        options: const AuthenticationOptions(
            useErrorDialogs: true, biometricOnly: false),
      );
    } on PlatformException catch (e) {
      print('Error using biometrics: $e');
      return false;
    }
  }

  /*  ==== ======= ===== */

  /*  ======= SignIn ====== */
  /*  ==== Email Verification and biometrics ===== */

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;

      if (user != null) {
        await user.reload(); // Refresh the user's data
        if (!user.emailVerified) {
          await sendVerificationEmail(user);
          res = 'verification_sent';
        } else {
          final userData = await getUserData(user.email!);
          print('User role: ${userData.role}');
          if (userData.role == UserRole.student ||
              userData.role == UserRole.professor) {
            if (await canAuthenticate()) {
              bool authenticated = await authenticate();
              if (authenticated) {
                res = 'success';
              } else {
                res = 'Biometric authentication failed';
              }
            } else {
              res = 'success';
            }
          } else if (userData.role == UserRole.admin) {
            res = 'success';
          } else {
            res = 'error';
          }
        }
      }
    } catch (e) {
      print('Error during login: $e');
      res = e.toString();
    }
    print('Login result: $res');
    return res;
  }

  /* ========== */

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  //getUser
  Future<UserData> getUserData(String email) async {
    try {
      final snapshot = await _fireStore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final userData = UserData.fromSnapshot(snapshot.docs.first);
        print('Fetched user data: ${userData.toJson()}');
        return userData;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  /* ========== */

  //getUserDetails
  Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    return UserData.fromSnapshot(snap);
  }

  Future<List<Sector>> getSectors() async {
    try {
      QuerySnapshot snapshot = await _fireStore.collection('sectors').get();
      return snapshot.docs.map((doc) => Sector.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching Sectors: $e");
      return [];
    }
  }

  Future<List<Group>> getGroups() async {
    try {
      QuerySnapshot snapshot = await _fireStore.collection('groups').get();
      return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching groups: $e");
      return [];
    }
  }

  Future<List<Student>> getStudents() async {
    try {
      QuerySnapshot snapshot = await _fireStore.collection('students').get();
      return snapshot.docs.map((doc) => Student.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }

  Future<List<Module>> getModules() async {
    try {
      QuerySnapshot snapshot = await _fireStore.collection('modules').get();
      return snapshot.docs.map((doc) => Module.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching modules: $e");
      return [];
    }
  }

  Future<List<Student>> getStudentsByModules(List<String> moduleIds) async {
    try {
      if (moduleIds.isEmpty) {
        return [];
      }

      QuerySnapshot snapshot = await _fireStore
          .collection('students')
          .where('modules', arrayContainsAny: moduleIds)
          .get();

      List<Student> students = snapshot.docs
          .map((doc) {
            try {
              return Student.fromSnapshot(doc);
            } catch (e) {
              print("Error mapping student: $e");
              return null; // Return null if mapping fails
            }
          })
          .where((student) => student != null)
          .cast<Student>()
          .toList(); // Filter out nulls and cast

      return students;
    } catch (e) {
      print("Error fetching students by modules: $e");
      return [];
    }
  }

  Future<void> addSector(Sector sector) async {
    try {
      await _fireStore.collection('sectors').doc(sector.id).set(sector.toMap());
    } catch (e) {
      print("Error adding sector: $e");
    }
  }

  Future<List<Professor>> getProfessors() async {
    try {
      QuerySnapshot snapshot = await _fireStore.collection('professors').get();
      return snapshot.docs.map((doc) => Professor.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching professors: $e");
      return [];
    }
  }

  Future<Map<String, String>> getProfessorDetails() async {
    QuerySnapshot snapshot = await _fireStore.collection('professors').get();
    Map<String, String> professorDetails = {};
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      professorDetails[doc.id] =
          data['name']; // Assuming each professor document has a 'name' field
    }
    return professorDetails;
  }

  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _fireStore
          .collection('schedules')
          .doc(schedule.id)
          .set(schedule.toMap());
    } catch (e) {
      print("Error adding sector: $e");
    }
  }

  Future<List<Schedule>> getSchedules() async {
    try {
      QuerySnapshot snapshot = await _fireStore.collection('schedules').get();
      print("Fetched Schedules: ${snapshot.docs.length}");
      return snapshot.docs.map((doc) => Schedule.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Fetched Schedules: $e");
      return [];
    }
  }

  Future<void> deleteSchedule(String id) async {
    await _fireStore.collection('schedules').doc(id).delete();
  }

/* =============== */

  /*  ======= Note ====== */
  Future<void> addNote(Note note) async {
    await _fireStore.collection('notes').doc(note.id).set(note.toMap());
  }

  Future<List<Note>> getNotesByStudent(String studentId) async {
    QuerySnapshot querySnapshot = await fireStore
        .collection('notes')
        .where('studentId', isEqualTo: studentId)
        .get();

    return querySnapshot.docs.map((doc) => Note.fromSnapshot(doc)).toList();
  }

  Future<void> addOrUpdateNote(Note note) async {
    QuerySnapshot existingNote = await fireStore
        .collection('notes')
        .where('studentId', isEqualTo: note.studentId)
        .where('moduleId', isEqualTo: note.moduleId)
        .limit(1)
        .get();

    if (existingNote.docs.isNotEmpty) {
      var existingNoteDoc = existingNote.docs.first;
      await fireStore.collection('notes').doc(existingNoteDoc.id).update({
        'practicalWork': note.practicalWork,
        'variousWork': note.variousWork,
      });
    } else {
      await fireStore.collection('notes').doc(note.id).set(note.toMap());
    }
  }

  Future<double> calculateAverageNotes(String studentId) async {
    List<Note> notes = await getNotesByStudent(studentId);
    if (notes.isEmpty) {
      return 0.0;
    }

    double totalAveragePerNote = 0.0;

    for (var note in notes) {
      double averagePerNote = (note.practicalWork + note.variousWork) / 2;
      totalAveragePerNote += averagePerNote;
    }

    double average = totalAveragePerNote / notes.length;
    return average;
  }

  Future<List<Note>> getNotesByStudentAndModule(
      String studentId, String moduleId) async {
    QuerySnapshot snapshot = await _fireStore
        .collection('notes')
        .where('studentId', isEqualTo: studentId)
        .where('moduleId', isEqualTo: moduleId)
        .get();
    return snapshot.docs.map((doc) => Note.fromSnapshot(doc)).toList();
  }

/*  ======= Module ====== */
//method to add new Module
  Future<void> addModule(Module module) async {
    await _fireStore.collection('modules').doc(module.id).set(module.toMap());
  }

  Future<Student?> getCurrentStudent() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snap =
            await _fireStore.collection('students').doc(currentUser.uid).get();
        if (snap.exists) {
          return Student.fromSnapshot(snap);
        }
      }
    } catch (e) {
      print('Error fetching current student: $e');
    }
    return null;
  }

  Stream<QuerySnapshot> getDocumentRequestsStream() {
    return _fireStore.collection('request').snapshots();
  }

  Stream<QuerySnapshot> getStudentNotificationsStream() {
    return FirebaseFirestore.instance.collection('notifications').snapshots();
  }

  Future<void> sendNotification(String studentId, String message) async {
    String notificationId = _fireStore.collection('notifications').doc().id;
    Notifications notifications = Notifications(
      id: notificationId,
      studentId: studentId,
      message: message,
      timestamp: DateTime.now(),
    );
    await _fireStore
        .collection('notifications')
        .doc(notificationId)
        .set(notifications.toMap());
  }

  Future<void> completeDocumentRequest(
      String requestId, String studentId, String studentName) async {
    try {
      // Update the request to mark it as completed
      await _fireStore.collection('request').doc(requestId).update({
        'status': 'completed',
      });

      await sendNotification(
        studentId,
        "Your Document request has been completed. You can go to receive the document.",
      );
    } catch (e) {
      print('Error completing document request: $e');
    }
  }

//
// //fetch All Module
// Future<List<Module>> getModules() async {
//   QuerySnapshot snapshot = await _fireStore.collection('modules').get();
//   return snapshot.docs.map((doc) => Module.fromSnapshot(doc)).toList();
// }

/* =============== */
/*  ======= Exam ====== */
//method to add new Module
// Future<void> addExam(Exam exam) async {
//   await _fireStore.collection('exams').doc(exam.id).set(exam.toMap());
// }
//
// //fetch All Module
// Future<List<Exam>> getExams(String moduleId) async {
//   QuerySnapshot snapshot = await _fireStore
//       .collection('exams')
//       .where('moduleId', isEqualTo: moduleId)
//       .get();
//   return snapshot.docs.map((doc) => Exam.fromSnapshot(doc)).toList();
// }

// add schedule
//   Future<void> addSchedule(Schedule schedule) async {
//     await _fireStore
//         .collection('schedules')
//         .doc(schedule.id)
//         .set(schedule.toMap());
//   }

//

// Future<void> sendVerificationCode() async {
//   User? user = _auth.currentUser;
//   if (user != null) {
//     await user.sendEmailVerification();
//   }
// }

/*= ====================== =*/

/*  ======= SignIn ====== */
/*  ==== Email Verification ===== */

// Future<String> loginUser({
//   required String email,
//   required String password,
// }) async {
//   String res = "Some error occurred";
//
//   try {
//     UserCredential authResult = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     if (authResult.user != null) {
//       await sendVerificationCode();
//       res = 'verification_sent';
//     }
//   } catch (e) {
//     print('Error during login: $e');
//     res = e.toString();
//   }
//   print('Login result: $res');
//   return res;
// } //login User
//
// Future<bool> completeLogin() async {
//   return await verifyCode();
// }

/*  ======= SignIn ====== */
/*  ==== Biometrics Verification ===== */
//
// Future<String> loginUser({
//   required String email,
//   required String password,
// }) async {
//   String res = "Some error occurred";
//
//   try {
//     UserCredential authResult = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);
//     if (authResult.user != null) {
//       final userData = await getUserData(authResult.user!.email!);
//       print('User role: ${userData.role}');
//       if (userData.role == UserRole.student) {
//         if (await canAuthenticate()) {
//           bool authenticated = await authenticate();
//           if (authenticated) {
//             res = 'success';
//           } else {
//             res = 'Biometric authentication failed';
//           }
//         } else {
//           res = 'success';
//         }
//       } else if (userData.role == UserRole.admin) {
//         res = 'success';
//       } else {
//         res = 'error';
//       }
//     }
//   } catch (e) {
//     print('Error during login: $e');
//     res.toString();
//   }
//   print('Login result: $res');
//   return res;
// } //login User

/*  ======= Courses ====== */

// add Course
// Future<void> addCourse(Course course) async {
//   await _fireStore.collection('courses').doc(course.id).set(course.toMap());
// }
//
// // fetch all Course
// Future<List<Course>> getCourses() async {
//   QuerySnapshot snapshot = await _fireStore.collection('courses').get();
//   return snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList();
// }

/* =============== */

// Future<bool> verifyCode() async {
//   User? user = _auth.currentUser;
//   if (user != null && user.emailVerified) {
//     return true;
//   }
//   return false;
// }
/*  ======= Schedule ====== */

// fetch all schedule
/* ================ */

/*  ======= Sector ====== */

// Future<void> addSector(Sector sector) async {
//   await _fireStore.collection('sectors').doc(sector.id).set(sector.toMap());
// }
//
// Future<List<Sector>> getSector() async {
//   QuerySnapshot snapshot = await _fireStore.collection('sectors').get();
//   return snapshot.docs.map((doc) => Sector.fromSnapshot(doc)).toList();
// }

/* ================ */

/*  ======= group ====== */
// Future<void> addGroup(Group group) async {
//   await _fireStore.collection('groups').doc(group.id).set(group.toMap());
// }
//
// Future<List<Group>> getGroups() async {
//   QuerySnapshot snapshot = await _fireStore.collection('groups').get();
//   return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
// }

/* ================ */

/*  ======= Student ====== */

// Future<void> addStudent(Student student) async {
//   await _fireStore
//       .collection('students')
//       .doc(student.uid)
//       .set(student.toMap());
// }
//
// Future<List<Student>> getStudent() async {
//   final snapshot = await _fireStore.collection('students').get();
//   return snapshot.docs.map((doc) => Student.fromSnapshot(doc)).toList();
// }
//
// Future<List<Student>> getStudents(String moduleId) async {
//   final snapshot = await _fireStore
//       .collection('students')
//       .where('modules', arrayContains: moduleId)
//       .get();
//   return snapshot.docs.map((doc) => Student.fromSnapshot(doc)).toList();
// }
//
// Future<List<Student>> getStudentsByModules(List<String> moduleIds) async {
//   try {
//     QuerySnapshot snapshot = await _fireStore
//         .collection('students')
//         .where('modules', arrayContainsAny: moduleIds)
//         .get();
//
//     return snapshot.docs.map((doc) => Student.fromSnapshot(doc)).toList();
//   } catch (e) {
//     print("Error fetching students by modules: $e");
//     return [];
//   }
// }

/* ================ */
/*  ======= professor ====== */
// Future<List<Student>> getProfessor() async {
//   final snapshot = await _fireStore.collection('professors').get();
//   return snapshot.docs.map((doc) => Student.fromSnapshot(doc)).toList();
// }

/* ================ */

// Future<void> sendSMSCode(String phoneNumber) async {
//   if (phoneNumber.isEmpty) {
//     print("Error: Phone Number is Empty");
//     return;
//   }
//   try {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         print(
//             'Phone number automatically verified and user signed in: $phoneNumber');
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print("Failed to verify phone number: ${e.message}");
//         if (e.code == 'invalid-phone-number') {
//           print('The provided phone number is not valid.');
//         } else {
//           print('Verification failed for some other reason: ${e.message}');
//         }
//       },
//       codeSent: (String verificationId, int? resendToken) async {
//         print('Code sent to $phoneNumber');
//         await _fireStore
//             .collection('users')
//             .doc(_auth.currentUser!.uid)
//             .update({'verificationId': verificationId});
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         print('Code auto-retrieval timeout for $phoneNumber');
//       },
//     );
//   } catch (e) {
//     print('Error sending SMS code: $e');
//   }
// } // Send SMS code

// Future<bool> verifySMSCode(String verificationId, String smsCode) async {
//   try {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: smsCode,
//     );
//     await _auth.signInWithCredential(credential);
//     return true;
//   } catch (e) {
//     print("Failed to signin with SMS code: $e");
//     return false;
//   }
// } // Verify SMS code

/* =============== */

// Future<void> storeStudent(Student student) async {
//   await FirebaseFirestore.instance
//       .collection('student')
//       .doc(student.uid)
//       .set(student.toMap());
// }

// Future<void> updateStudentScores(
//     String uid, Map<String, double> newScores) async {
//   await FirebaseFirestore.instance.doc(uid).update({'scores': newScores});
// }

//method to add new Group
//   Future<void> addGroup(Group group) async {
//     await _fireStore.collection('groups').doc(group.id).set(group.toMap());
//   }
//
//   //fetch All Group
//   Future<List<Group>> getGroups() async {
//     QuerySnapshot snapshot = await _fireStore.collection('groups').get();
//     return snapshot.docs.map((doc) => Group.fromSnapshot(doc)).toList();
//   }
}
