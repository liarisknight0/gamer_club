import 'package:flutter/material.dart';

class GamerCard extends StatelessWidget {
  final String username;
  final String title;
  final String rank;

  const GamerCard({
    super.key,
    required this.username,
    required this.title,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // The overall card shape and glowing border
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow:[
          BoxShadow(
            color: const Color(0xFF00FFCC).withOpacity(0.5), // Neon Cyan Glow
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:[
            Color(0xFF2A0845), // Deep Purple
            Color(0xFF000000), // Pitch Black
            Color(0xFF0F2027), // Dark Blue-Grey
          ],
        ),
        border: Border.all(
          color: const Color(0xFF00FFCC).withOpacity(0.8), // Card Border
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18), // Clips inner content so it doesn't spill over the rounded corners
        child: Stack(
          children:[
            // Background Pattern/Texture (Using a subtle grid or icon)
            Positioned(
              right: -50,
              bottom: -50,
              child: Icon(
                Icons.sports_esports,
                size: 250,
                color: Colors.white.withOpacity(0.03),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  // TOP ROW: Title & Rank
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF00FFCC),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF00FF).withOpacity(0.2), // Neon Pink background
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFF00FF)),
                        ),
                        child: Text(
                          rank,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(), // Pushes the avatar to the middle

                  // CENTER: Avatar
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: const DecorationImage(
                          // Placeholder image until we add real avatars
                          image: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Gamer'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(), // Pushes the bottom info down

                  // BOTTOM: Username & Platforms
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Platform Icons Row (Placeholders for Steam, PS, Xbox)
                  Row(
                    children:[
                      _buildPlatformIcon(Icons.computer, 'PC'),
                      const SizedBox(width: 10),
                      _buildPlatformIcon(Icons.gamepad, 'Console'),
                      const SizedBox(width: 10),
                      _buildPlatformIcon(Icons.phone_iphone, 'Mobile'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A small helper widget to build the platform badges
  Widget _buildPlatformIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children:[
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}