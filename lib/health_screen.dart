import 'package:flutter/material.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.health_and_safety, size: 80, color: Color(0xFF10B981)),
          const SizedBox(height: 20),
          const Text(
            "Health Module",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "AI-powered health insights and recommendations",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}