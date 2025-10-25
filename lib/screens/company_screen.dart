import 'package:flutter/material.dart';
// Use relative path for the next screen
import 'model_screen.dart';

// --- SHARED DATA ---
// Place the updated carData map (from above) here for now
const Map<String, Map<String, dynamic>> carData = {
  'honda': { 'name': 'Honda', 'models': { '2022': [ {'name': 'City', 'tagline': 'Smart & Efficient Sedan'}, {'name': 'Civic', 'tagline': 'Sporty & Modern Sedan'}, {'name': 'Vezel', 'tagline': 'Stylish Compact SUV'}, ], } },
  'toyota': { 'name': 'Toyota', 'models': { '2022': [ {'name': 'Corolla Altis 1.6x', 'tagline': 'Everyday Comfort & Reliability'}, {'name': 'Grande 1.8x', 'tagline': 'Premium Features & Power'}, {'name': 'Hilux', 'tagline': 'Powerful & Durable Pickup'}, {'name': 'Yaris ATIV', 'tagline': 'Smart & Efficient City Car'}, {'name': 'Fortuner', 'tagline': 'Rugged 7-Seater SUV'}, ], } },
  'nissan': { 'name': 'Nissan', 'models': { '2022': [ {'name': 'Magnite', 'tagline': 'Bold & Stylish Compact SUV'}, {'name': 'Kicks', 'tagline': 'Modern Urban Crossover'}, ], } },
};
// --- END DATA ---

class CompanyScreen extends StatefulWidget {
  final String selectedYear;

  const CompanyScreen({ super.key, required this.selectedYear, });

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  String _selectedCompanyId = carData.keys.first;

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
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Select Car Company', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium,),
            const SizedBox(height: 8),
            Text('${widget.selectedYear} Models', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(height: 40),

            ...carData.entries.map((entry) {
              final companyId = entry.key;
              final companyInfo = entry.value;
              final bool isSelected = (companyId == _selectedCompanyId);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _CompanyButton(
                  title: companyInfo['name'] ?? 'Unknown',
                  isSelected: isSelected,
                  onPressed: () => setState(() => _selectedCompanyId = companyId),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push( context, MaterialPageRoute( builder: (context) => ModelScreen(
                  selectedYear: widget.selectedYear,
                  selectedCompanyId: _selectedCompanyId,
                ), ), );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ Text('Continue'), SizedBox(width: 8), Icon(Icons.arrow_forward_ios, size: 14), ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for the company button (no changes needed)
class _CompanyButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;
  const _CompanyButton({ required this.title, required this.isSelected, required this.onPressed, });
  @override
  Widget build(BuildContext context) { /* ... Keep button code exactly as before ... */
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[900]?.withOpacity(0.7) : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all( color: isSelected ? Colors.blue[400]! : Colors.grey[800]!, width: isSelected ? 2 : 1, ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text( title, style: const TextStyle( color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, ), ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
          ],
        ),
      ),
    );
  }
}