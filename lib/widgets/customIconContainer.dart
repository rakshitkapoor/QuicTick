import 'package:flutter/material.dart';

class CustomIconContainer extends StatelessWidget {
  final IconData iconData;
  final double height;
  final double padding;

  CustomIconContainer({
    required this.iconData,
    this.height = 0.005,
    this.padding = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        height: screenSize.height * height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Icon(iconData),
      ),
    );
  }
}