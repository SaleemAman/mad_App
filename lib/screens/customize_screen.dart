import 'package:flutter/material.dart';

class CustomizeScreen extends StatefulWidget {
  // Receives data from the ModelScreen
  final String selectedYear;
  final String selectedCompany; // Display name (e.g., "Honda")
  final String selectedModel; // Model name (e.g., "City")
  final String selectedVariant; // Engine variant (e.g., "Standard")

  const CustomizeScreen({
    super.key,
    required this.selectedYear,
    required this.selectedCompany,
    required this.selectedModel,
    required this.selectedVariant,
  });

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  // --- STATE VARIABLES for customization ---
  String _currentView = 'front';
  String _packageType = 'stock';
  String _interiorColor = 'beige';

  // --- LOGIC TO GET LOCAL ASSET PATH ---
  String getCurrentImagePath() {
    // !! IMPORTANT !! - This is still HARDCODED to your Honda City 2022 assets
    // because those are the only visual assets available in the project.
    // Selecting "Toyota Corolla" will still show the Honda City for now.
    String carIdentifier = 'honda_city';
    String yearIdentifier = '2022';
    String carPath = 'assets/images/$carIdentifier/$yearIdentifier/';

    String filename;
    if (_currentView == 'interior') {
      filename = _packageType == 'stock'
          ? 'stock_interior.jpg'
          : (_interiorColor == 'burgundy'
          ? 'sport_interior_burgundy.jpg'
          : 'sport_interior_black.jpg');
    } else { // Exterior view
      filename = '${_packageType}_$_currentView.jpg';
    }
    // Example path: "assets/images/honda_city/2022/stock_front.jpg"
    return '$carPath$filename';
  }

  // --- LOGIC FOR CONDITIONAL BUTTONS ---
  bool _showInteriorSelector() {
    return _currentView == 'interior' && _packageType == 'sport';
  }
  bool _isInteriorStockBeige() {
    return _currentView == 'interior' && _packageType == 'stock';
  }

  // Update package and corresponding interior state
  void _updatePackage(String newPackage) {
    setState(() {
      _packageType = newPackage;
      if (newPackage == 'stock') {
        _interiorColor = 'beige';
      } else { // Sport
        if (_interiorColor == 'beige') {
          _interiorColor = 'burgundy'; // Default to burgundy when switching to Sport
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- DEFINE STYLES based on current state ---
    bool isSport = _packageType == 'sport';
    Color controlPanelColor = isSport ? Theme.of(context).colorScheme.surface : Colors.white;
    Color headingColor = isSport ? Colors.red[400]! : Colors.black87;
    Color labelColor = isSport ? Colors.red[400]! : Colors.grey[700]!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Display Selected Car Info in the AppBar
        title: Text(
          '${widget.selectedCompany} ${widget.selectedModel}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${widget.selectedYear} ${isSport ? '⚡' : ''}',
                style: TextStyle(
                  fontSize: 13,
                  color: isSport ? Colors.red[400] : Colors.blue[300],
                ),
              ),
            ),
          ),
        ],
      ),

      // --- MAIN BODY ---
      body: Column(
        children: [
          // --- IMAGE VIEWER ---
          Expanded(
            child: Container(
              color: Colors.white, // White background for image contrast
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                    child: child,
                  );
                },
                child: Image.asset(
                  getCurrentImagePath(),
                  key: ValueKey(getCurrentImagePath()),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('Error: Image asset not found!\nCheck path: ${getCurrentImagePath()}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 10)));
                  },
                ),
              ),
            ),
          ),

          // --- CONTROL PANEL ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: controlPanelColor,
              borderRadius: const BorderRadius.only( topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                  child: Text( 'CUSTOMIZE ${isSport ? '⚡' : ''}', style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: headingColor)),
                ),
                // View Buttons
                Row(
                  children: [
                    _buildControlButton(context, 'Front', _currentView == 'front', isSport, () => setState(() => _currentView = 'front')),
                    const SizedBox(width: 10),
                    _buildControlButton(context, 'Back', _currentView == 'back', isSport, () => setState(() => _currentView = 'back')),
                    const SizedBox(width: 10),
                    _buildControlButton(context, 'Interior', _currentView == 'interior', isSport, () => setState(() => _currentView = 'interior')),
                  ],
                ),
                const SizedBox(height: 20),
                // Package Buttons
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text( 'Package', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Row(
                  children: [
                    _buildControlButton(context, 'Stock', _packageType == 'stock', isSport, () => _updatePackage('stock')),
                    const SizedBox(width: 10),
                    _buildControlButton(context, 'Sport ⚡', _packageType == 'sport', isSport, () => _updatePackage('sport')),
                  ],
                ),
                const SizedBox(height: 20),
                // Interior Color Buttons (Conditional)
                AnimatedOpacity(
                  opacity: (_showInteriorSelector() || _isInteriorStockBeige()) ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Visibility(
                    visible: (_showInteriorSelector() || _isInteriorStockBeige()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Text( 'Interior', style: TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Row(
                          children: [
                            _buildControlButton(context, 'Beige', _isInteriorStockBeige(), isSport, null),
                            const SizedBox(width: 10),
                            _buildControlButton(context, 'Burgundy', _interiorColor == 'burgundy' && !_isInteriorStockBeige(), isSport, _isInteriorStockBeige() ? null : () => setState(() => _interiorColor = 'burgundy')),
                            const SizedBox(width: 10),
                            _buildControlButton(context, 'Black', _interiorColor == 'black' && !_isInteriorStockBeige(), isSport, _isInteriorStockBeige() ? null : () => setState(() => _interiorColor = 'black')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- Reusable Helper Widget for building all buttons ---
  Widget _buildControlButton(BuildContext context, String text, bool isSelected, bool isSportMode, VoidCallback? onPressed) {
    Color bgColor, fgColor, borderColor = Colors.transparent;
    double elevation = 0;
    bgColor = Colors.grey[200]!; fgColor = Colors.black54;
    if (isSelected) { bgColor = Colors.blue[600]!; fgColor = Colors.white; elevation = 2; }
    if (isSportMode) { bgColor = Colors.grey[800]!.withOpacity(0.5); fgColor = Colors.grey[400]!; borderColor = Colors.grey[700]!; elevation = 0;
    if (isSelected) { bgColor = Colors.red[600]!; fgColor = Colors.white; borderColor = Colors.red[400]!; elevation = 2; } }
    if (onPressed == null) { bgColor = isSportMode ? Colors.grey[800]!.withOpacity(0.2) : Colors.grey[100]!; fgColor = isSportMode ? Colors.grey[600]! : Colors.grey[400]!; borderColor = isSportMode ? Colors.grey[700]!.withOpacity(0.5) : Colors.grey[300]!; elevation = 0; }

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor, foregroundColor: fgColor, disabledBackgroundColor: bgColor, disabledForegroundColor: fgColor, elevation: elevation,
          shadowColor: isSelected ? (isSportMode ? Colors.red[900] : Colors.blue[900]) : Colors.transparent,
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(isSportMode ? 8 : 12), side: BorderSide(color: borderColor, width: 1.0) ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text( text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, )),
      ),
    );
  }
}