import 'package:flutter/material.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
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
              child: Text("Profile Screen Admin"),
            ),
          ],
        ),
      ),
    );
  }
}
