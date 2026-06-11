import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, size: 80, color: Color(0xFF10B981)),
          const SizedBox(height: 20),
          const Text(
            "Education Module",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "Learn with AI-powered educational tools",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}