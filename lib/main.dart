import 'package:flutter/material.dart';
import 'landing_screen.dart';

void main() {
  runApp(const BoraApp());
}

class BoraApp extends StatelessWidget {
  const BoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bora AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF10B981),
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}