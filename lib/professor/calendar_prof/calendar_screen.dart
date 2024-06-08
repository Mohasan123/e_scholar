import 'package:flutter/material.dart';

class CalendarProfessor extends StatefulWidget {
  const CalendarProfessor({super.key});

  @override
  State<CalendarProfessor> createState() => _CalendarProfessorState();
}

class _CalendarProfessorState extends State<CalendarProfessor> {
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
              child: Text("Calendar Screen Prof"),
            ),
          ],
        ),
      ),
    );
  }
}
