import 'package:e_scolar_app/admin/home_admin/widgets/container_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constant/constant_svg.dart';
import '../../constant/pallete_color.dart';

class HomeBodyProf extends StatefulWidget {
  const HomeBodyProf({super.key});

  @override
  State<HomeBodyProf> createState() => _HomeBodyProfState();
}

class _HomeBodyProfState extends State<HomeBodyProf> {
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
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  width: double.maxFinite,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorPalette.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Prof: Prof1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  "Class XI-B | Roll no: 04",
                                  style: TextStyle(
                                    color: Colors.white,
                                    wordSpacing: 1,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            child: CircleAvatar(minRadius: 30.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                    text: 'Demander une Document',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8.0),
                  ContainerImage(
                    image: IconAdmin.sentDiploma,
                    text: 'Ajouter une Note',
                    onTap: () {
                      context.go('/addNote');
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
