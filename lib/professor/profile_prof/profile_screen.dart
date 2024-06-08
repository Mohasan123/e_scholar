import 'package:flutter/material.dart';

class ProfileProfessor extends StatefulWidget {
  const ProfileProfessor({super.key});

  @override
  State<ProfileProfessor> createState() => _ProfileProfessorState();
}

class _ProfileProfessorState extends State<ProfileProfessor> {
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
              child: Text("Profile Screen Prof"),
            ),
          ],
        ),
      ),
    );
  }
}
