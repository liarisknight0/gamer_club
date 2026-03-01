import 'package:flutter/material.dart';
import '../widgets/gamer_card.dart';

class BinderScreen extends StatelessWidget {
  const BinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Some dummy data to fill our binder
    final List<Map<String, String>> collectedCards =[
      {'user': 'xX_Sniper_Xx', 'title': 'Tryhard', 'rank': 'Radiant'},
      {'user': 'CozyGamerGirl', 'title': 'Completionist', 'rank': 'Gold'},
      {'user': 'NoobMaster69', 'title': 'Casual', 'rank': 'Bronze'},
      {'user': 'Faker', 'title': 'Pro Player', 'rank': 'Challenger'},
    ];

    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: collectedCards.length,
        itemBuilder: (context, index) {
          final cardData = collectedCards[index];
          return GamerCard(
            username: cardData['user']!,
            title: cardData['title']!,
            rank: cardData['rank']!,
          );
        },
      ),
    );
  }
}