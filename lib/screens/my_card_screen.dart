import 'package:flutter/material.dart';
import '../widgets/gamer_card.dart'; // Import our new card!

class MyCardScreen extends StatelessWidget {
  const MyCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            // Look how clean this is! We just call our widget and pass the data.
            const SizedBox(
              width: 300,
              height: 450,
              child: GamerCard(
                username: 'NinjaSlayer99',
                title: 'FPS Veteran',
                rank: 'Diamond III',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Later, this will open a screen to edit the username/colors
              },
              icon: const Icon(Icons.edit, color: Colors.black),
              label: const Text('Edit Card', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FFCC), // Neon Cyan
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}