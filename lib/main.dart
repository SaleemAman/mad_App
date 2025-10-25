import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Start screen

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
      // --- THEME UPDATE ---
      // This new, detailed theme will fix the color issues everywhere.
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark navy background
        fontFamily: 'Roboto',

        // Define a consistent color scheme
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFf97316), // Orange for accents
          secondary: Color(0xFFd97706), // Amber for other accents
          surface: Color(0xFF1E293B), // Dark slate for cards/panels
          background: Color(0xFF0F172A), // Same as scaffold
          onPrimary: Colors.white, // <-- FIX: Text on orange surfaces
          onSecondary: Colors.white, // Text on amber surfaces
          onSurface: Colors.white, // Text on cards/panels
          onBackground: Colors.white, // Default text color
        ),

        // Define consistent styles for all AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A), // Dark navy to match background
          foregroundColor: Colors.white, // <-- FIX: Ensures title and icons are white
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
            color: Colors.white, // <-- FIX: Explicitly set title color
          ),
        ),

        // Define consistent styles for all Text
        textTheme: TextTheme(
          // For main screen titles like "Select Car Year"
          titleMedium: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          // For subtitles like "Choose the manufacturing year"
          bodySmall: TextStyle(
            color: Colors.blue[300],
            fontSize: 14,
          ),
          // For button text
          labelLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white, // <-- FIX: Explicitly set button text color
          ),
        ),

        // Define consistent styles for all main action buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB), // Bright blue
            foregroundColor: Colors.white, // <-- FIX: Ensures text/icons on button are white
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}