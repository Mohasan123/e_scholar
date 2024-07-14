import 'package:e_scolar_app/constant/pallete_color.dart';
import 'package:e_scolar_app/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../auth/auth_methods.dart';

class CalendarStudent extends StatefulWidget {
  const CalendarStudent({super.key});

  @override
  State<CalendarStudent> createState() => _CalendarStudentState();
}

class _CalendarStudentState extends State<CalendarStudent> {
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

  // Future<void> _downloadImage(String firebasePath, String fileName) async {
  //   try {
  //     print('Fetching download URL...');
  //     String downloadURL = await FirebaseStorage.instance
  //         .refFromURL(firebasePath)
  //         .getDownloadURL();
  //     print('Download URL: $downloadURL');
  //
  //     var response = await http.get(Uri.parse(downloadURL));
  //     if (response.statusCode == 200) {
  //       if (await Permission.storage.request().isGranted) {
  //         Directory? externalDir = await getExternalStorageDirectory();
  //         File downloadToFile = File('${externalDir?.path}/$fileName');
  //
  //         await downloadToFile.writeAsBytes(response.bodyBytes);
  //         print('File written to ${downloadToFile.path}');
  //
  //         bool fileExists = await downloadToFile.exists();
  //         if (fileExists) {
  //           print('File successfully downloaded: ${downloadToFile.path}');
  //         } else {
  //           print('File not found at path: ${downloadToFile.path}');
  //         }
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content:
  //                   Text('Downloaded $fileName to ${downloadToFile.path}')),
  //         );
  //       } else {
  //         throw Exception('Storage permission not granted');
  //       }
  //     } else {
  //       throw Exception('Failed to download image');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error downloading image: $e')),
  //     );
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
              onPressed: () {
                context.go('/');
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
                      // _downloadImage(
                      //   'gs://e-scolar-app-938f3.appspot.com/images/image1.jpeg',
                      //   'image1.jpeg',
                      // );
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
