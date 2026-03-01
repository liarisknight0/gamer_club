import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import QR package
import '../widgets/gamer_card.dart';

class MyCardScreen extends StatelessWidget {
  const MyCardScreen({super.key});

  // A function to show the QR Code in a popup dialog
  void _showQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Scan to Collect',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF00FFCC), fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 250,
            height: 250,
            child: QrImageView(
              data: "gamerclub:NinjaSlayer99:FPS Veteran:Diamond III", // The data inside the QR!
              version: QrVersions.auto,
              backgroundColor: Colors.white, // QR codes need a white background to scan easily
            ),
          ),
          actions:[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
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

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.black),
                  label: const Text('Edit Card', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                const SizedBox(width: 20),
                // NEW QR BUTTON
                ElevatedButton.icon(
                  onPressed: () => _showQRCode(context),
                  icon: const Icon(Icons.qr_code, color: Colors.black),
                  label: const Text('Share QR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FFCC), // Neon Cyan
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}