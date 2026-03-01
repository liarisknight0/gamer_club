import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;

  Future<void> _processScannedCard(String scannedUid) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // 1. Prevent scanning your own card
    if (scannedUid == currentUser.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.redAccent, content: Text("You can't collect your own card!", style: TextStyle(color: Colors.white))),
      );
      return;
    }

    try {
      // 2. Save the scanned User's ID into YOUR collected_cards sub-collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('collected_cards')
          .doc(scannedUid) // We use their UID as the document ID so you can't collect the same person twice!
          .set({
        'collected_at': FieldValue.serverTimestamp(), // Records when you scanned it
      });

      // 3. Show Success Message!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF00FFCC),
            content: Text('Card Collected & Saved to Binder!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving card: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() => isScanning = false); // Pause scanning

                  final String scannedUid = barcode.rawValue!;
                  await _processScannedCard(scannedUid);

                  // Wait 3 seconds before allowing another scan
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) setState(() => isScanning = true);
                  });
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00FFCC), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const Positioned(
            bottom: 50, left: 0, right: 0,
            child: Text(
              'Align QR code within the frame to collect',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, backgroundColor: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}