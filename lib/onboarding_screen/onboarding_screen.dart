import 'package:e_scolar_app/constant/pallete_color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
<<<<<<< HEAD
=======
  final int _currentIndex = 0;
  final List<String> _onboardingTexts = [
    "Welcome to Onboarding Page 1",
    "This is Onboarding Page 2",
    "Last Page of Onboarding",
  ];

>>>>>>> 7961d6c2c2f8e2551eeff971619272f84bc666cf
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
