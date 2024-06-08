import 'package:e_scolar_app/constant/pallete_color.dart';
import 'package:flutter/material.dart';
import "package:iconsax/iconsax.dart";

class ContainerImage extends StatefulWidget {
  final String image;
  final String text;
  final Function()? onTap;

  const ContainerImage({
    super.key,
    required this.image,
    required this.text,
    required this.onTap,
  });

  @override
  State<ContainerImage> createState() => _ContainerImageState();
}

class _ContainerImageState extends State<ContainerImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: ColorPalette.primaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 5.0, top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                  height: 60, // Adjust height as needed
                ),
                Text(
                  widget.text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Iconsax.arrow_right_14,
                  color: Colors.white,
                  size: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
