import 'package:flutter/material.dart';

class CalendarStudent extends StatefulWidget {
  const CalendarStudent({super.key});

  @override
  State<CalendarStudent> createState() => _CalendarStudentState();
}

class _CalendarStudentState extends State<CalendarStudent> {
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
              child: Text("Calendar Screen Student"),
            ),
          ],
        ),
      ),
    );
  }
}
