import 'package:flutter/material.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.business, size: 80, color: Color(0xFF10B981)),
          const SizedBox(height: 20),
          const Text(
            "Business Module",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "Business analytics and market insights",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}