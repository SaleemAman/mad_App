import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const SaloModsApp());
}

class SaloModsApp extends StatelessWidget {
  const SaloModsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaloMods',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep Navy
        fontFamily: 'Roboto', // Or your preferred font
        useMaterial3: true,

        // Color Palette
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),    // Bright Blue (Action)
          secondary: Color(0xFFFF3B30),  // Red (Sport Accents)
          surface: Color(0xFF1E293B),    // Card Backgrounds
          background: Color(0xFF0F172A), // Main Background
          onPrimary: Colors.white,
          onSurface: Colors.white,
        ),

        // AppBar Styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),

        // Button Styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: Colors.blue.withOpacity(0.5),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}