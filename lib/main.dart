import 'package:flutter/material.dart';
import 'screens/binder_screen.dart';
import 'screens/my_card_screen.dart';
import 'screens/scanner_screen.dart';

void main() {
  runApp(const GamerClubApp());
}

class GamerClubApp extends StatelessWidget {
  const GamerClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamer Club',
      debugShowCheckedModeBanner: false,
      // Here we define the "Gamer" Dark Theme
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark grey
        primaryColor: const Color(0xFF00FFCC), // Neon Cyberpunk Cyan
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFCC),
          secondary: Color(0xFFFF00FF), // Neon Pink for accents
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;


  final List<Widget> _screens =[
    const BinderScreen(),
    const MyCardScreen(),
    const ScannerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAMER CLUB'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF00FFCC), // Neon Cyan when selected
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.style), // Card binder icon
            label: 'Binder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // User card icon
            label: 'My Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner), // Scanner icon
            label: 'Scan',
          ),
        ],
      ),
    );
  }
}