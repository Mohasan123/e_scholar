import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/models/userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    String rsp = "Some Error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserData userData =
            UserData(email: email, name: name, uid: cred.user!.uid);

        await _fireStore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userData.toJson());
        rsp = "success";
      }
    } catch (err) {
      rsp = err.toString();
    }
    return rsp;
  } //Register user

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please Enter All the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  } //login User
}
