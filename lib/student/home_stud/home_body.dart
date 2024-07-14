import 'package:e_scolar_app/admin/home_admin/widgets/container_icon.dart';
import 'package:e_scolar_app/constant/constant_svg.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_methods.dart';
import '../../constant/pallete_color.dart';

class HomeBodyStudent extends StatefulWidget {
  const HomeBodyStudent({super.key});

  @override
  State<HomeBodyStudent> createState() => _HomeBodyStudentState();
}

class _HomeBodyStudentState extends State<HomeBodyStudent>
    with SingleTickerProviderStateMixin {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white38,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                    future: _authMethods.getCurrentStudent(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                            child: Text('unable to retrieve student data'));
                      } else {
                        Student student = snapshot.data!;
                        return Container(
                          width: double.maxFinite,
                          height: 100,
                          decoration: BoxDecoration(
                            color: ColorPalette.primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Etudiant: ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            Text(
                                              " ${student.name}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.0,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Apogee no:",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    letterSpacing: 1.5,
                                                  ),
                                                ),
                                                const SizedBox(width: 5.0),
                                                Text(
                                                  student.codeApogee,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                    wordSpacing: 1,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 20.0),
                                    child: CircleAvatar(minRadius: 30.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ),
              Column(
                children: [
                  ContainerImage(
                    image: IconAdmin.addPlaner,
                    text: 'Voir le Planing',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8.0),
                  ContainerImage(
                    image: IconAdmin.addDocument,
                    text: 'Demander un Document',
                    onTap: () {
                      context.go('/requestDocument');
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ContainerImage(
                    image: IconAdmin.sentDiploma,
                    text: 'Voir les notes',
                    onTap: () {
                      String? studentId = _authMethods.getCurrentUserId();
                      if (studentId != null) {
                        context.go('/studentNote/$studentId');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Unable to retrieve student ID')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
