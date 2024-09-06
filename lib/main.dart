import 'package:codesix/screens/chatBotScreen.dart';
import 'package:codesix/screens/dashboard.dart';
import 'package:codesix/screens/onboardingScreen.dart';
import 'package:codesix/screens/ticketBooking.dart';
import 'package:flutter/material.dart';

final theme = ThemeData( 
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Colors.teal,
    secondary: Colors.white,
    tertiary: Colors.white
  )
);

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: theme,
      home: OnboardingScreen(),
    );
  }
}
