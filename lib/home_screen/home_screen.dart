import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:e_scolar_app/home_body/home_body.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../calendar_body/calendar_screen.dart';
import '../constant/pallete_color.dart';
import '../profile_body/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TabItem> items = [
    const TabItem(icon: Iconsax.home_1),
    const TabItem(icon: Iconsax.calendar_1),
    const TabItem(icon: Iconsax.user),
  ];

  int _currentIndex = 0;

  final List<Widget> _screen = [
    const HomeBody(),
    const CalendarScreen(),
    const ProfileBody(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        // title: const Row(
        //   children: [
        //     Icon(Icons.code), //image of logo
        //     Text("hello"), //name of logo
        //   ],
        // ),
        leading: IconButton(
          onPressed: () {},
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
      body: _screen[_currentIndex],
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
