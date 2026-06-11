import 'package:flutter/material.dart';

class AgricultureScreen extends StatelessWidget {
  const AgricultureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.agriculture, size: 80, color: Color(0xFF10B981)),
          const SizedBox(height: 20),
          const Text(
            "Agriculture Module",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "Smart farming solutions and crop management",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}