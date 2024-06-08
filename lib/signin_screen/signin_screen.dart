import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/signin_screen/verify_sms_screen.dart';
import 'package:e_scolar_app/signin_screen/widgets/circular_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constant/constant_svg.dart';
import '../constant/pallete_color.dart';
import '../models/userdata.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authMethods = AuthMethods();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  // Future<void> loginUser() async {
  //   String res = await AuthMethods().loginUser(
  //       email: emailController.text,
  //       password: passController.text,
  //       role: _selectedRole!);
  //   if (res == "success") {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => HomeScreen(
  //                   role: _selectedRole!,
  //                 )));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(res)),
  //     );
  //   }
  // }
  Future<void> loginUser() async {
    final email = emailController.text;
    final password = passController.text;
    final result = await _authMethods.loginUser(
      email: email,
      password: password,
    );
    print('Login user result: $result');
    if (result == 'success') {
      try {
        final userData = await _authMethods.getUserData(email);
        print('Navigating based on role: ${userData.role}');
        if (userData.role == UserRole.student) {
          if (userData.phone.isNotEmpty) {
            await _authMethods.sendSMSCode(userData.phone);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VerifySMSScreen(phoneNumber: userData.phone)));
          } else {
            // Handle case where the user does not have a phone number
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Phone number is empty'),
              ),
            );
          }
        } else if (userData.role == UserRole.admin) {
          context.go('/home/admin');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Role not found'),
            ),
          );
        }
      } catch (e) {
        print('Error during user data fetching or navigation: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching user data: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(
            gradient: ColorPalette.gradiantColor,
          ),
          child: Column(
            children: [
              const SizedBox(height: 80.0),
              const Text("Welcome Back",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const Text(
                "Sign in with your email and password ",
                style: TextStyle(fontSize: 12.0),
              ),
              const Text(
                "or continue with social media",
                style: TextStyle(fontSize: 12.0),
              ),
              const SizedBox(height: 8.0),
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
              const SizedBox(height: 20.0),
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
                    suffixIcon: const Icon(Icons.lock_outline),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ]),
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
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 1,
                      ),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     RichText(
              //       text: TextSpan(
              //         text: "Don't have an account?",
              //         style: const TextStyle(
              //             color: Colors.black, fontSize: 15, letterSpacing: 1),
              //         children: <TextSpan>[
              //           TextSpan(
              //               text: " Sign Up",
              //               style: const TextStyle(
              //                   color: ColorPalette.primaryColor,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold),
              //               recognizer: TapGestureRecognizer()
              //                 ..onTap = () {
              //                   context.go('/signUp');
              //                 }),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
