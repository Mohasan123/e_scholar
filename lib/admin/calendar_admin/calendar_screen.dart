import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../auth/auth_methods.dart';
import '../../models/schedule.dart';

class CalendarAdmin extends StatefulWidget {
  const CalendarAdmin({super.key});

  @override
  State<CalendarAdmin> createState() => _CalendarAdminState();
}

class _CalendarAdminState extends State<CalendarAdmin> {
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

  Future<void> _removeItem(int index) async {
    final removedItem = _schedules[index];
    _schedules.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removedItem, animation),
    );
    await _authMethods.deleteSchedule(removedItem.id);
    AnimatedSnackBar.material(
      'Item removed !!',
      type: AnimatedSnackBarType.error,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    ).show(context);
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  return _buildListItem(schedule, animation, index);
                },
              ),
            ),
    );
  }

  Widget _buildListItem(
      Schedule schedule, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Dismissible(
        key: Key(schedule.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _removeItem(index);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
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
              Text(
                schedule.sectors.join(', '), // Sector names as title
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemovedItem(Schedule item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.sectors.join(', '),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Room: ${item.room}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Text(
              'Start: ${formatDateTime(item.startTime)}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Text(
              'End: ${formatDateTime(item.endTime)}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Text(
              'Students: ${item.students.join(', ')}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Text(
              'Professors: ${item.professors.join(', ')}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Text(
              'Modules: ${item.modules.join(', ')}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
