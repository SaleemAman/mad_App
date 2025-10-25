import 'package:flutter/material.dart';
import 'year_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // This text already looked okay, but let's use the theme for consistency
              Text(
                'SALOMODS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 2.0),
              ),
              const SizedBox(height: 12),
              Text(
                'Customize Your Car',
                style: Theme.of(context).textTheme.bodySmall, // Use theme style
              ),
              const SizedBox(height: 48),
              // This button will now correctly get its white text color from the theme
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const YearScreen()),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Get Started'), // Text style is now handled by the theme
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}