import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  /*  ==== Biometrics & Email Verification  ===== */
  Future<void> loginUser() async {
    final email = emailController.text;
    final password = passController.text;

    try {
      final result = await _authMethods.loginUser(
        email: email,
        password: password,
      );
      print('Login user result: $result');
      if (result == 'verification_sent') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Email Verification'),
            content: const Text(
                'A verification link has been sent to your email. Please verify and log in again.'),
            actions: [
              TextButton(
                style: ButtonStyle(),
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (result == 'success') {
        await completeLogin();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
          ),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      if (e.toString().contains("too-many-requests")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Too many requests. Please try again later.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login error: $e'),
          ),
        );
      }
    }
  }

  Future<void> completeLogin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isVerified = await _authMethods.verifyEmail(user);
      if (isVerified) {
        try {
          final userData = await _authMethods.getUserData(user.email!);
          print('Navigating based on role: ${userData.role}');
          if (userData.role == UserRole.student) {
            context.go('/');
          } else if (userData.role == UserRole.admin) {
            context.go('/home/admin');
          } else if (userData.role == UserRole.professor) {
            context.go('/home/professor');
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
          const SnackBar(
            content: Text('Email not verified'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user currently signed in'),
        ),
      );
    }
  }

  /*  ==== ======= ===== */

  /*  ==== Biometrics Verification ===== */

  // Future<void> loginUser() async {
  //   final email = emailController.text;
  //   final password = passController.text;
  //   final result = await _authMethods.loginUser(
  //     email: email,
  //     password: password,
  //   );
  //   print('Login user result: $result');
  //   if (result == 'success') {
  //     try {
  //       final userData = await _authMethods.getUserData(email);
  //       print('Navigating based on role: ${userData.role}');
  //       if (userData.role == UserRole.student) {
  //         context.go('/');
  //       } else if (userData.role == UserRole.admin) {
  //         context.go('/home/admin');
  //       } else if (userData.role == UserRole.professor) {
  //         context.go('/home/professor');
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Role not found'),
  //           ),
  //         );
  //       }
  //     } catch (e) {
  //       print('Error during user data fetching or navigation: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error fetching user data: $e'),
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(result),
  //       ),
  //     );
  //   }
  // }

  /*  ==== ======= ===== */

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
              const SizedBox(height: 120.0),
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
              const SizedBox(height: 30.0),
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
                  obscureText: true,
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
              const SizedBox(height: 30.0),
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
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  width: 450,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // if (await AuthMethods.canAuthenticate()) {
                        //   bool authenticated = await AuthMethods.authenticate();
                        //   if (authenticated) {
                        //     await loginUser();
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text("Biometrics Auth Failed")),
                        //     );
                        //   }
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content: Text("Biometrics Auth not Available")),
                        //   );
                        // }
                        await loginUser();
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
            ],
          ),
        ),
      ),
    );
  }

/*  ==== Email Verification ===== */
// Future<void> loginUser() async {
//   final email = emailController.text;
//   final password = passController.text;
//   try {
//     final result = await _authMethods.loginUser(
//       email: email,
//       password: password,
//     );
//     print('Login user result: $result');
//     if (result == 'verification_sent') {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Email Verification'),
//           content: const Text(
//               'A verification link has been sent to your email. Please verify and log in again.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else if (result == 'success') {
//       await completeLogin();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result),
//         ),
//       );
//     }
//   } catch (e) {
//     print("Error during login: $e");
//     if (e.toString().contains("too-many-requests")) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Too many requests. Please try again later.'),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Login error: $e'),
//         ),
//       );
//     }
//   }
// }
//
// Future<void> completeLogin() async {
//   final isVerified = await _authMethods.completeLogin();
//   if (isVerified) {
//     try {
//       final userData = await _authMethods.getUserData(emailController.text);
//       print('Navigating based on role: ${userData.role}');
//       if (userData.role == UserRole.student) {
//         context.go('/');
//       } else if (userData.role == UserRole.admin) {
//         context.go('/home/admin');
//       } else if (userData.role == UserRole.professor) {
//         context.go('/home/professor');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Role not found'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error during user data fetching or navigation: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error fetching user data: $e'),
//         ),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Email not verified'),
//       ),
//     );
//   }
// }

/*  ==== ======= ===== */
}
