import 'package:flutter/material.dart';
import 'company_screen.dart';

class YearScreen extends StatefulWidget {
  const YearScreen({super.key});

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  final List<String> _years = ['2024', '2023', '2022', '2021', '2020'];
  String _selectedYear = '2022';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar title will now be white because of the theme
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // This title is now more prominent using the theme style
                  Text(
                    'Select Car Year',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the manufacturing year',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall, // Use theme style
                  ),
                  const SizedBox(height: 40),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _years.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (context, index) {
                      final year = _years[index];
                      final isSelected = (year == _selectedYear);
                      return _YearButton(
                        text: year,
                        isSelected: isSelected,
                        onPressed: () => setState(() => _selectedYear = year),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // This button will now correctly get its white text color from the theme
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyScreen(selectedYear: _selectedYear),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Continue'), // Text style is now handled by the theme
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget for the year button (this code is fine, no changes needed)
class _YearButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const _YearButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[900]?.withOpacity(0.7) : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[400]! : Colors.grey[800]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: Colors.blue[400]!.withOpacity(0.3), blurRadius: 10)] : [],
        ),
        child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
      ),
    );
  }
}