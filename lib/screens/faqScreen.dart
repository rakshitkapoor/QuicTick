import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "FAQ Screen",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
