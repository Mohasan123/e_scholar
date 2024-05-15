import 'package:e_scolar_app/home_screen/widgets/linear_progress.dart';
import 'package:flutter/material.dart';

import '../constant/pallete_color.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                height: 150,
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor.withOpacity(0.8),
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
                                "Ismail",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Progress Performance",
                            style: TextStyle(
                              color: Colors.white,
                              wordSpacing: 1,
                              letterSpacing: 1,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        LinearProgress(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Row(
              children: [
                Text("hello"),
                Text("hello"),
                Text("hello"),
                Text("hello"),
                Text("hello"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
