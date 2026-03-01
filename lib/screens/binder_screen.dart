import 'package:flutter/material.dart';

class BinderScreen extends StatelessWidget {
  const BinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          childAspectRatio: 0.7, // Trading card aspect ratio (taller than wide)
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6, // Placeholder for 6 cards
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A), // Dark grey card background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00FFCC), width: 1), // Neon Cyan border
            ),
            child: const Center(
              child: Text(
                'Empty Slot',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}