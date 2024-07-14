import 'package:e_scolar_app/constant/pallete_color.dart';
import 'package:e_scolar_app/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../auth/auth_methods.dart';

class CalendarProfessor extends StatefulWidget {
  const CalendarProfessor({super.key});

  @override
  State<CalendarProfessor> createState() => _CalendarProfessorState();
}

class _CalendarProfessorState extends State<CalendarProfessor> {
  final AuthMethods _authMethods = AuthMethods();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Schedule> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    List<Schedule> schedules = await _authMethods.getSchedules();
    setState(() {
      _schedules = schedules;
      _isLoading = false;
    });

    for (int i = 0; i < _schedules.length; i++) {
      _listKey.currentState?.insertItem(i);
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
              onPressed: () {
                context.go('/home/professor');
              },
              icon: const Icon(
                Iconsax.arrow_circle_left,
                color: ColorPalette.primaryColor,
              )),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white38,
              ),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _schedules.length,
                itemBuilder: (context, index, animation) {
                  final schedule = _schedules[index];
                  return _buildListItem(schedule, animation);
                },
              ),
            ),
    );
  }

  Widget _buildListItem(Schedule schedule, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.8),
              Colors.lightBlueAccent.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    schedule.sectors.join(', '), // Sector names as title
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: () {
                      // Add download functionality here
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Icon(Icons.class_, color: Colors.white),
                const SizedBox(width: 5.0),
                Text(
                  'Classe: ${schedule.room}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white),
                const SizedBox(width: 5.0),
                Text(
                  'Debut: ${formatDateTime(schedule.startTime)}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white),
                const SizedBox(width: 5.0),
                Text(
                  'Fin: ${formatDateTime(schedule.endTime)}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 5.0),
                Text(
                  'Professors: ${schedule.professors.join(', ')}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const Icon(Icons.book, color: Colors.white),
                const SizedBox(width: 5.0),
                Flexible(
                  child: Text(
                    'Modules: ${schedule.modules.join(', ')}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
