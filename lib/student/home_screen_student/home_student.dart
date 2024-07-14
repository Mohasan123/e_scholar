import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/student/home_stud/home_body.dart';
import 'package:e_scolar_app/student/profile_stud/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../auth/auth_methods.dart';
import '../../constant/pallete_color.dart';
import '../../signin_screen/signin_screen.dart';
import '../calendar_stud/calendar_screen.dart';
import 'notificationStudent/notificationStudent.dart';

class HomeStudent extends StatefulWidget {
  const HomeStudent({super.key});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  List<TabItem> items = [
    const TabItem(icon: Iconsax.home_1),
    const TabItem(icon: Iconsax.calendar_1),
    const TabItem(icon: Iconsax.user),
  ];

  int _currentIndex = 0;
  bool _notificationDialogOpen = false;

  final List<Widget> _screen = [
    const HomeBodyStudent(),
    const CalendarStudent(),
    const ProfileStudent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          content: const Text(
            'Are you sure you want to sign out ?',
            style: TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              onPressed: () {
                // Handle the confirm action
                FirebaseAuth.instance.signOut();
                context.go('/signIn');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            _showAlertDialog(context);
          },
          icon: const Icon(
            Iconsax.logout,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.search_normal,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20.0),
          StreamBuilder(
            stream: AuthMethods().getStudentNotificationsStream(),
            builder: (context, snapshot) {
              print('Snapshot Data: ${snapshot.data}');
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var docs = snapshot.data!.docs;
                print('Snapshot Data Documents: ${snapshot.data!.docs}');
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        _navigateToNotificationScreen(context, docs);
                      },
                      icon: Icon(
                        Iconsax.notification,
                        size: 30,
                        color: _notificationDialogOpen
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                    if (!_notificationDialogOpen)
                      Positioned(
                        right: 11,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            maxHeight: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${docs.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return IconButton(
                  onPressed: () {
                    print('hello 2');
                  },
                  icon: const Icon(
                    Iconsax.notification,
                    size: 30,
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 20.0),
        ],
        backgroundColor: ColorPalette.primaryColor,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return _screen[_currentIndex];
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const SignInScreen();
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 20.0),
        child: BottomBarFloating(
          borderRadius: BorderRadius.circular(25.0),
          items: items,
          backgroundColor: ColorPalette.primaryColor,
          color: Colors.white,
          colorSelected: Colors.white,
          indexSelected: _currentIndex,
          paddingVertical: 15,
          onTap: _onItemTapped,
          animated: true,
          iconSize: 25,
        ),
      ),
    );
  }

  void _navigateToNotificationScreen(
      BuildContext context, List<QueryDocumentSnapshot> docs) {
    setState(() {
      _notificationDialogOpen = true;
    });
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => const StudentNotifications(),
      ),
    )
        .then((_) {
      setState(() {
        _notificationDialogOpen = false;
      });
    });
  }
}
