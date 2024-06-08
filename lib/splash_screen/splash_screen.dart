import 'package:flutter/material.dart';

import '../constant/pallete_color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: ColorPalette.gradiantColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Image.asset("assets/splash/e_school.png"),
          ),
        )
      ),
    );
  }
}
