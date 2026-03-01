import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // Controller to manage the camera
  final MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true; // To prevent scanning the same code 100 times a second

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          // 1. The actual camera view
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() => isScanning = false); // Pause scanning

                  final String scannedData = barcode.rawValue!;

                  // Show a success popup!
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF00FFCC),
                      content: Text(
                          'Card Found! Data: $scannedData',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );

                  // Wait 3 seconds before allowing another scan
                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() => isScanning = true);
                  });
                }
              }
            },
          ),

          // 2. A cool targeting overlay so it looks like a sci-fi scanner
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00FFCC), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // 3. Instructions text
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
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