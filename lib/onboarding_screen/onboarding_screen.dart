import 'package:e_scolar_app/constant/pallete_color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: ColorPalette.gradiantColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/scholarship.json"),
            const SizedBox(height: 40.0),
            const Text("lorem ipsum for Onboarding"),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                //go to signUp
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
