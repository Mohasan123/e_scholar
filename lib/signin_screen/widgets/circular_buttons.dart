import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularButton extends StatelessWidget {
  final String image;

  const CircularButton({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color.fromRGBO(80, 194, 201, 0.6)),
          child: Center(
            child: SvgPicture.asset(
              image,
              width: 30.0,
              height: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
