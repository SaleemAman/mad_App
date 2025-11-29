import 'package:flutter/material.dart';
import 'model_screen.dart';

class CompanyScreen extends StatelessWidget {
  final List<Map<String, String>> companies = [
    {
      'name': 'Honda',
      'logo': 'assets/logos/honda_logo.png',
      'id': 'honda',
    },
    {
      'name': 'Toyota',
      'logo': 'assets/logos/toyota_logo.png',
      'id': 'toyota',
    },
    {
      'name': 'Haval',
      'logo': 'assets/logos/haval_logo.png',
      'id': 'haval',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101D42), // Your dark blue theme
      appBar: AppBar(
        title: const Text('Select Manufacturer'),
        backgroundColor: const Color(0xFF101D42),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF1A2B5E), // Slightly lighter blue for cards
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Image.asset(
                companies[index]['logo']!,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.car_repair, color: Colors.white, size: 50),
              ),
              title: Text(
                companies[index]['name']!,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
              onTap: () {
                // FIXED: We now navigate directly to ModelScreen without passing a 'Year'
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModelScreen(
                      companyId: companies[index]['id']!,
                      companyName: companies[index]['name']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}