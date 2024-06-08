import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:e_scolar_app/professor/calendar_prof/calendar_screen.dart';
import 'package:e_scolar_app/professor/home_prof/home_body.dart';
import 'package:e_scolar_app/professor/profile_prof/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../constant/pallete_color.dart';
import '../../signin_screen/signin_screen.dart';

class HomeProfessor extends StatefulWidget {
  const HomeProfessor({super.key});

  @override
  State<HomeProfessor> createState() => _HomeProfessorState();
}

class _HomeProfessorState extends State<HomeProfessor> {
  List<TabItem> items = [
    const TabItem(icon: Iconsax.home_1),
    const TabItem(icon: Iconsax.calendar_1),
    const TabItem(icon: Iconsax.user),
  ];

  int _currentIndex = 0;

  final List<Widget> _screen = [
    const HomeBodyProf(),
    const CalendarProfessor(),
    const ProfileProfessor(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/signIn');
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.notification,
              size: 30,
              color: Colors.white,
            ),
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
}
