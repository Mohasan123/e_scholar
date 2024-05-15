import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constant/constant_svg.dart';
import '../constant/pallete_color.dart';
import '../signin_screen/widgets/circular_buttons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> registerUser() async {
      String resp = await AuthMethods().registerUser(
          email: emailController.text,
          name: nameController.text,
          password: passController.text);

      if (resp == "success") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: ColorPalette.gradiantColor,
          ),
          child: Column(
            children: [
              const SizedBox(height: 80.0),
              const Text("Register Account",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10.0),
              const Text(
                "Complete your details or continue",
                style: TextStyle(fontSize: 12.0),
              ),
              const Text(
                "with social media",
                style: TextStyle(fontSize: 12.0),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, right: 20.0, left: 20.0, bottom: 8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    hintText: "Enter your Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: const Icon(Iconsax.personalcard),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, right: 20.0, left: 20.0, bottom: 8.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: const Icon(Icons.email_outlined),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, left: 20.0, bottom: 10.0),
                child: TextFormField(
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: const Icon(Iconsax.eye_slash),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, left: 20.0, bottom: 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Re-enter your password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: const Icon(Iconsax.eye_slash),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  width: 450,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  child: ElevatedButton(
                    onPressed: () {
                      registerUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularButton(image: ConstSvg.googleSvg),
                      SizedBox(width: 8.0),
                      CircularButton(image: ConstSvg.twitterSvg),
                      SizedBox(width: 8.0),
                      CircularButton(image: ConstSvg.facebookSvg),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              const Text(
                "By continuing your confirm that you agree",
                style: TextStyle(fontSize: 12.0),
              ),
              const Text(
                "with our Term and Condition",
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
