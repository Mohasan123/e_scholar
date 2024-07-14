import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../auth/auth_methods.dart';
import '../../../constant/pallete_color.dart';
import '../../../models/notification.dart';

class StudentNotifications extends StatelessWidget {
  const StudentNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorPalette.primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Iconsax.arrow_circle_left,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: AuthMethods().getStudentNotificationsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var docs = snapshot.data!.docs;
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                child: Column(
                  children: docs.map((doc) {
                    final notification = Notifications.fromSnapshot(doc);
                    print('Notification ID: ${notification.id}');
                    print('Student ID: ${notification.studentId}');
                    print('Message: ${notification.message}');
                    print('Timestamp: ${notification.timestamp}');
                    return ExpansionTile(
                      title: Text("Notification"),
                      children: [
                        ListTile(
                          title: Text("Message: ${notification.message}"),
                          subtitle:
                              Text("Received at: ${notification.timestamp}"),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
              child: Text('No notifications found.'),
            );
          }
        },
      ),
    );
  }
}
