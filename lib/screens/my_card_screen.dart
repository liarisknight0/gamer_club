import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gamer_card.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({super.key});

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {
  // Get the current logged-in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Controllers for our Edit Dialog
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();

  // Function to show the QR Code
  void _showQRCode(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Scan to Collect', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF00FFCC), fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 250, height: 250,
            child: QrImageView(
              data: uid, // Now the QR code just holds their unique User ID!
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ),
          ),
          actions:[
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close', style: TextStyle(color: Colors.white))),
          ],
        );
      },
    );
  }

  // Function to Edit the Card Data
  void _editCardDialog(Map<String, dynamic>? currentData) {
    // Pre-fill the text boxes with their current data (or defaults)
    _nameController.text = currentData?['username'] ?? 'Player One';
    _titleController.text = currentData?['title'] ?? 'Newbie';
    _rankController.text = currentData?['rank'] ?? 'Unranked';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Edit Gamer Card', style: TextStyle(color: Color(0xFF00FFCC))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Gamer Tag', labelStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title (e.g., FPS Veteran)', labelStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
              TextField(controller: _rankController, decoration: const InputDecoration(labelText: 'Rank/Level (e.g., Diamond III)', labelStyle: TextStyle(color: Colors.grey)), style: const TextStyle(color: Colors.white)),
            ],
          ),
          actions:[
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FFCC)),
              onPressed: () async {
                // SAVE DATA TO FIREBASE!
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
                  'username': _nameController.text.trim(),
                  'title': _titleController.text.trim(),
                  'rank': _rankController.text.trim(),
                }, SetOptions(merge: true)); // Merge means it updates existing, or creates if new

                if (mounted) Navigator.pop(context); // Close dialog
              },
              child: const Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Function to securely Log Out
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // No need to navigate, main.dart will automatically catch the state change later
  }

  @override
  Widget build(BuildContext context) {
    // If user is somehow not logged in, show an error
    if (currentUser == null) return const Center(child: Text('Not logged in', style: TextStyle(color: Colors.white)));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions:[
          IconButton(icon: const Icon(Icons.logout, color: Colors.redAccent), onPressed: _logout),
        ],
      ),
      // StreamBuilder listens to the database LIVE!
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00FFCC)));
          }

          // Extract the data from Firebase (or use defaults if they haven't set it yet)
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final username = data?['username'] ?? 'Player One';
          final title = data?['title'] ?? 'Newbie';
          final rank = data?['rank'] ?? 'Unranked';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                SizedBox(
                  width: 300,
                  height: 450,
                  child: GamerCard(
                    username: username,
                    title: title,
                    rank: rank,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    ElevatedButton.icon(
                      onPressed: () => _editCardDialog(data),
                      icon: const Icon(Icons.edit, color: Colors.black),
                      label: const Text('Edit Card', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () => _showQRCode(context, currentUser!.uid),
                      icon: const Icon(Icons.qr_code, color: Colors.black),
                      label: const Text('Share QR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FFCC), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}