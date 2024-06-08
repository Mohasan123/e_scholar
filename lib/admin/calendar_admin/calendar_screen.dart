import 'package:flutter/material.dart';

class CalendarAdmin extends StatefulWidget {
  const CalendarAdmin({super.key});

  @override
  State<CalendarAdmin> createState() => _CalendarAdminState();
}

class _CalendarAdminState extends State<CalendarAdmin> {
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
              child: Text("Calendar Screen Admin"),
            ),
          ],
        ),
      ),
    );
  }
}
