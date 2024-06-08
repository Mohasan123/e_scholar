import 'package:flutter/material.dart';

class ProfileStudent extends StatefulWidget {
  const ProfileStudent({super.key});

  @override
  State<ProfileStudent> createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white38,
        ),
        child: const Column(
          children: [
            Center(
              child: Text("Profile Screen student"),
            ),
          ],
        ),
      ),
    );
  }
}
