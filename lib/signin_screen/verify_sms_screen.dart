import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/student/home_screen_student/home_student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifySMSScreen extends StatefulWidget {
  final String? phoneNumber;

  const VerifySMSScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<VerifySMSScreen> createState() => _VerifySMSScreenState();
}

class _VerifySMSScreenState extends State<VerifySMSScreen> {
  TextEditingController codeController = TextEditingController();
  late TextEditingController phoneController;
  final _auth = AuthMethods();

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.phoneNumber);
  }

  Future<void> verifyCode() async {
    final code = codeController.text;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      final verificationId = snapshot.data()?['verificationId'];
      if (verificationId != null) {
        final isValid = await _auth.verifySMSCode(verificationId, code);
        if (isValid) {
          context.go('/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid code, please try again.'),
            ),
          );
        }
      }
    }
  }

  Future<void> sendCode() async {
    final phoneNumber = phoneController.text;
    if (phoneNumber.isNotEmpty) {
      await _auth.sendSMSCode(phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid phone number")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Enter phone number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendCode,
              child: Text('Verify'),
            ),
            ElevatedButton(
              onPressed: verifyCode,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
