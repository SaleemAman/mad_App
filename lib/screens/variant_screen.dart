import 'package:flutter/material.dart';
// Use relative path for the next screen
import 'customize_screen.dart';

// --- Placeholder Data (Move to models later) ---
// Define a simple class for variants for clarity
class CarVariantInfo {
  final String name;
  final String description;
  final String power;
  final String price; // Keep price as string for now

  const CarVariantInfo({
    required this.name,
    required this.description,
    required this.power,
    required this.price,
  });
}

// Example variants for Honda (adjust as needed)
final List<CarVariantInfo> hondaVariants = [
  const CarVariantInfo( name: '1.2L', description: 'Efficient city driving', power: '90 HP', price: '₹10.50 Lakh',),
  const CarVariantInfo( name: '1.5L', description: 'Balanced performance', power: '121 HP', price: '₹13.20 Lakh',),
  // Add other Honda variants if applicable
];
// --- End Data ---

class VariantScreen extends StatefulWidget {
  final String selectedYear;
  final String selectedCompanyId; // Receives company ID

  const VariantScreen({
    super.key,
    required this.selectedYear,
    required this.selectedCompanyId,
  });

  @override
  State<VariantScreen> createState() => _VariantScreenState();
}

class _VariantScreenState extends State<VariantScreen> {
  // State variable for selected variant
  String _selectedVariantName = '1.5L'; // Default selection

  // For now, assume only Honda variants are available
  List<CarVariantInfo> _variantsToShow = hondaVariants;

  @override
  void initState() {
    super.initState();
    // TODO: Later, add logic here to select the correct variant list
    // based on widget.selectedCompanyId and widget.selectedYear
    _variantsToShow = hondaVariants; // Hardcoded for now
    // Set a default if the current default isn't in the list
    if (!_variantsToShow.any((v) => v.name == _selectedVariantName)) {
      _selectedVariantName = _variantsToShow.isNotEmpty ? _variantsToShow.first.name : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get company display name from data
    final companyDisplayName = carCompanyData[widget.selectedCompanyId]?['name'] ?? widget.selectedCompanyId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SALOMODS', style: TextStyle(letterSpacing: 1.5)),
        backgroundColor: Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          ),
        ),
        // Center content and limit width
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Select Engine Variant',
                      textAlign: TextAlign.center,
                      style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$companyDisplayName ${widget.selectedYear}', // Show selected info
                      textAlign: TextAlign.center,
                      style: TextStyle( color: Colors.blue[300], fontSize: 14,),
                    ),
                    const SizedBox(height: 40),

                    // Grid for variant buttons
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns like Figma
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8, // Make buttons taller
                      ),
                      itemCount: _variantsToShow.length,
                      itemBuilder: (context, index) {
                        final variant = _variantsToShow[index];
                        final bool isSelected = (variant.name == _selectedVariantName);

                        // Build each variant button
                        return _VariantButton( // Use helper widget
                          variant: variant,
                          isSelected: isSelected,
                          onPressed: () {
                            setState(() { _selectedVariantName = variant.name; });
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 40), // Space before button

                    // Continue Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30.0),),
                      ),
                      onPressed: () {
                        // Navigate to CustomizeScreen, passing all selections
                        Navigator.push( context, MaterialPageRoute( builder: (context) => CustomizeScreen(
                          selectedYear: widget.selectedYear,
                          selectedCompany: companyDisplayName, // Pass display name
                          selectedModel: 'City', // Hardcoded model for now
                          selectedVariant: _selectedVariantName,
                        ), ), );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text( 'Continue to Customize', style: TextStyle(fontSize: 14, color: Colors.white), ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Helper Widget for Variant Button Styling ---
class _VariantButton extends StatelessWidget {
  final CarVariantInfo variant;
  final bool isSelected;
  final VoidCallback onPressed;

  const _VariantButton({ required this.variant, required this.isSelected, required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[900]?.withOpacity(0.7) : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all( color: isSelected ? Colors.blue[400]! : Colors.transparent, width: 2, ),
          boxShadow: isSelected ? [ BoxShadow( color: Colors.blue[400]!.withOpacity(0.3), blurRadius: 10, spreadRadius: 2, ) ] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( variant.name, style: const TextStyle( color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,), ),
            const SizedBox(height: 8),
            Text( variant.power, style: TextStyle( color: Colors.blue[300], fontSize: 14, fontWeight: FontWeight.w600, ), ),
            const SizedBox(height: 8),
            Text( variant.description, style: TextStyle( color: Colors.blue[200]?.withOpacity(0.7), fontSize: 12, ), maxLines: 2, overflow: TextOverflow.ellipsis,),
            const Spacer(), // Pushes price to bottom
            Text( variant.price, style: TextStyle( color: Colors.blue[200], fontSize: 14, fontWeight: FontWeight.w500, ), ),
          ],
        ),
      ),
    );
  }
}

// --- Temporary Data (Needs to be defined or imported) ---
// Make sure carCompanyData is accessible here if needed, e.g., defined globally or passed
// For now, using the name directly from the widget's selectedCompanyId
const Map<String, Map<String, dynamic>> carCompanyData = {
  'honda': { 'name': 'Honda', 'description': 'Reliable & Efficient', },
  'toyota': { 'name': 'Toyota', 'description': 'Trusted Worldwide', },
  'nissan': { 'name': 'Nissan', 'description': 'Innovation That Excites', },
};