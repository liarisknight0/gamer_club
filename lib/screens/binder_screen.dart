import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gamer_card.dart';

class BinderScreen extends StatelessWidget {
  const BinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('Please log in to see your binder.'));
    }

    return Scaffold(
      // 1. Listen to YOUR collection of scanned IDs
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('collected_cards')
            .orderBy('collected_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00FFCC)));
          }

          final collectedDocs = snapshot.data?.docs ??[];

          if (collectedDocs.isEmpty) {
            return const Center(
              child: Text(
                'Your Binder is empty.\nGo scan some QR codes!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          // 2. Build the Grid
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: collectedDocs.length,
            itemBuilder: (context, index) {
              final collectedUid = collectedDocs[index].id;

              // 3. For every ID in your binder, fetch their actual Gamer Card data!
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(collectedUid).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(20)),
                      child: const Center(child: CircularProgressIndicator(color: Color(0xFFFF00FF))),
                    );
                  }

                  final userData = userSnapshot.data?.data() as Map<String, dynamic>?;

                  // If they deleted their account or data is missing, show a fallback
                  final username = userData?['username'] ?? 'Unknown Player';
                  final title = userData?['title'] ?? 'N/A';
                  final rank = userData?['rank'] ?? 'Unranked';

                  return GamerCard(
                    username: username,
                    title: title,
                    rank: rank,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}