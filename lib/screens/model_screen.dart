import 'package:flutter/material.dart';
import 'customize_screen.dart'; // <--- THIS IMPORT IS CRITICAL

class ModelScreen extends StatefulWidget {
  final String companyId;   // e.g., 'honda'
  final String companyName; // e.g., 'Honda'

  const ModelScreen({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  // This Map defines exactly which models appear for each company
  final Map<String, List<Map<String, String>>> modelsData = {
    'honda': [
      {
        'name': 'City (2021-2025)',
        'folder': 'city_2021_2025', // Must match your folder name in assets
        'tagline': 'Aspire / 1.2 / 1.5',
      },
    ],
    'toyota': [
      {
        'name': 'Corolla Grande (2020-2025)',
        'folder': 'corolla_2020_2025',
        'tagline': 'Altis / Grande X',
      },
    ],
    'haval': [
      {
        'name': 'Haval H6 (2020-2025)',
        'folder': 'h6_2020_2025',
        'tagline': 'HEV / 1.5T / 2.0T',
      },
    ],
  };

  List<Map<String, String>> _currentModels = [];

  @override
  void initState() {
    super.initState();
    // Load the models for the selected company ID
    _currentModels = modelsData[widget.companyId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.companyName} Models'),
        backgroundColor: const Color(0xFF101D42), // Matches gradient start
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF101D42), Color(0xFF1E3A8A)],
          ),
        ),
        child: _currentModels.isEmpty
            ? Center(
          child: Text(
            'Coming Soon!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white54),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: _currentModels.length,
          itemBuilder: (context, index) {
            final car = _currentModels[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _ModelButton(
                title: car['name']!,
                subtitle: car['tagline']!,
                onPressed: () {
                  // Navigate to CustomizeScreen with the correct Folder Path
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomizeScreen(
                        companyName: widget.companyName,
                        modelName: car['name']!,
                        folderName: car['folder']!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Helper Widget for the Buttons
class _ModelButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const _ModelButton({
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3), // Slightly darker for contrast
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)), // Subtle blue border
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 16),
          ],
        ),
      ),
    );
  }
}