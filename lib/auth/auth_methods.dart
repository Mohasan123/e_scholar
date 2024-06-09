import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:e_scolar_app/models/userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../models/exam.dart';
import '../models/module.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final authBioMetrics = LocalAuthentication();

  FirebaseFirestore get fireStore => _fireStore;

  //biometrics Auth permission
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

  //Add User ==> Student Or Professor
  Future<String> registerUser({
    required String email,
    required String name,
    required String password,
    required String phone,
    required UserRole role,
    required List<String> modules,
  }) async {
    String result = "Some Error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (cred.user != null) {
          String uid = cred.user!.uid;
          if (role == UserRole.student) {
            Student student = Student(
              uid: uid,
              name: name,
              email: email,
              modules: modules,
            );
            await _fireStore
                .collection('students')
                .doc(uid)
                .set(student.toMap());
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

  //Login User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        final userData = await getUserData(authResult.user!.email!);
        print('User role: ${userData.role}');
        if (userData.role == UserRole.student) {
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

          //   if (userData.phone.isNotEmpty) {
          //     // await sendSMSCode(userData.phone);
          //     res = 'success';
          //   } else {
          //     print('Error: Phone number is empty');
          //     res = 'Phone number is empty';
          //   }
          // } else {
          //   res = 'success';
        } else if (userData.role == UserRole.admin) {
          res = 'success';
        } else {
          res = 'error';
        }
      }
    } catch (e) {
      print('Error during login: $e');
      res.toString();
    }
    print('Login result: $res');
    return res;
  } //login User

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

  //getUserDetails
  Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    return UserData.fromSnapshot(snap);
  }

// Future<void> storeStudent(Student student) async {
//   await FirebaseFirestore.instance
//       .collection('student')
//       .doc(student.uid)
//       .set(student.toMap());
// }

// Future<Student> getStudent(String uid) async {
//   final snapshot =
//       await FirebaseFirestore.instance.collection('student').doc(uid).get();
//   return Student.fromSnapshot(snapshot);
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

  //method to add new Module
  Future<void> addModule(Module module) async {
    await _fireStore.collection('modules').doc(module.id).set(module.toMap());
  }

  //fetch All Module
  Future<List<Module>> getModules() async {
    QuerySnapshot snapshot = await _fireStore.collection('modules').get();
    return snapshot.docs.map((doc) => Module.fromSnapshot(doc)).toList();
  }

  //method to add new Module
  Future<void> addExam(Exam exam) async {
    await _fireStore.collection('exams').doc(exam.id).set(exam.toMap());
  }

  //fetch All Module
  Future<List<Exam>> getExams(String moduleId) async {
    QuerySnapshot snapshot = await _fireStore
        .collection('exams')
        .where('moduleId', isEqualTo: moduleId)
        .get();
    return snapshot.docs.map((doc) => Exam.fromSnapshot(doc)).toList();
  }
}
