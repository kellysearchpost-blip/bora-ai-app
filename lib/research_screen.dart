import 'package:flutter/material.dart';

class ResearchScreen extends StatelessWidget {
  const ResearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.science, size: 80, color: Color(0xFF10B981)),
          const SizedBox(height: 20),
          const Text(
            "Research Module",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "AI-powered research tools and data analysis",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}