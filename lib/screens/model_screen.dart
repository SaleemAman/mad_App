import 'package:flutter/material.dart';
// Import the shared data structure
import 'company_screen.dart';
// Import the final screen
import 'customize_screen.dart';

class ModelScreen extends StatefulWidget {
  final String selectedYear;
  final String selectedCompanyId;

  const ModelScreen({
    super.key,
    required this.selectedYear,
    required this.selectedCompanyId,
  });

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  late String _companyDisplayName;
  // Now stores a list of Maps, each like {'name': 'City', 'tagline': '...'}
  late List<Map<String, String>> _availableModels;

  @override
  void initState() {
    super.initState();
    // Initialize data
    _companyDisplayName = carData[widget.selectedCompanyId]?['name'] ?? widget.selectedCompanyId;

    // Safely get the list of model maps
    final modelsData = carData[widget.selectedCompanyId]?['models']?[widget.selectedYear];
    if (modelsData is List) {
      // Ensure each item in the list is the expected Map format
      _availableModels = modelsData
          .whereType<Map>() // Filter out any non-map items
          .map((modelMap) => Map<String, String>.from(modelMap)) // Convert to the correct type
          .toList();
    } else {
      _availableModels = []; // Default to empty list if data is missing/wrong
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SALOMODS'),
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
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          ),
        ),
        child: _availableModels.isEmpty
            ? Center( // Show message if no models
          child: Text(
            'No models found for\n$_companyDisplayName ${widget.selectedYear}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.yellow),
          ),
        )
            : ListView( // Display list of models
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Select Car Model', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 8),
            Text('$_companyDisplayName ${widget.selectedYear}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(height: 40),

            // Create a button for each available model map
            ..._availableModels.map((modelInfo) {
              final modelName = modelInfo['name'] ?? 'Unknown Model';
              final modelTagline = modelInfo['tagline'] ?? ''; // Get tagline

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _ModelButton( // Use helper widget
                  title: modelName,
                  subtitle: modelTagline, // Pass tagline to button
                  onPressed: () {
                    // Navigate to the final CustomizeScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomizeScreen(
                          selectedYear: widget.selectedYear,
                          selectedCompany: _companyDisplayName,
                          selectedModel: modelName,
                          // Pass a default/placeholder variant for now
                          selectedVariant: 'Standard', // Example default
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Helper widget for the model button's appearance
class _ModelButton extends StatelessWidget {
  final String title;
  final String subtitle; // Added subtitle for tagline
  final VoidCallback onPressed;

  const _ModelButton({required this.title, required this.subtitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2), // Simple background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!), // Simple border
        ),
        child: Row(
          children: [
            Expanded(
              child: Column( // Use Column for title and subtitle
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle.isNotEmpty) // Only show subtitle if it exists
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[400], // Lighter text for tagline
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
          ],
        ),
      ),
    );
  }
}