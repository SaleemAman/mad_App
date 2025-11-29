import 'package:flutter/material.dart';

class CustomizeScreen extends StatefulWidget {
  final String companyName;
  final String modelName;
  final String folderName;

  const CustomizeScreen({
    super.key,
    required this.companyName,
    required this.modelName,
    required this.folderName,
  });

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  // --- STATE VARIABLES ---
  String _currentView = 'front';
  String _packageType = 'stock';
  String _interiorColor = 'beige';

  // --- PATH GENERATOR ---
  String getCurrentImagePath() {
    String companyFolder = widget.companyName.toLowerCase();
    String modelFolder = widget.folderName;
    String basePath = 'assets/images/$companyFolder/$modelFolder/';

    String filename;
    if (_currentView == 'interior') {
      if (_packageType == 'stock') {
        filename = 'stock_interior.jpg';
      } else {
        if (_interiorColor == 'burgundy') filename = 'sport_interior_burgundy.jpg';
        else if (_interiorColor == 'black') filename = 'sport_interior_black.jpg';
        else filename = 'sport_interior_burgundy.jpg';
      }
    } else {
      filename = '${_packageType}_$_currentView.jpg';
    }
    return '$basePath$filename';
  }

  void _updatePackage(String newPackage) {
    setState(() {
      _packageType = newPackage;
      // Reset interior logic when switching packages
      if (newPackage == 'stock') {
        _interiorColor = 'beige';
      } else {
        if (_interiorColor == 'beige') _interiorColor = 'burgundy';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSport = _packageType == 'sport';

    // --- THEME COLORS ---
    // STOCK THEME (Light & Classy)
    Color stockPanelColor = const Color(0xFFF5F7FA); // Light Grey-Blue
    Color stockTextColor = const Color(0xFF101D42);  // Navy Text
    Color stockAccentColor = const Color(0xFF101D42); // Navy Blue Buttons

    // SPORT THEME (Dark & Aggressive)
    Color sportPanelColor = const Color(0xFF101D42); // Navy Background
    Color sportTextColor = Colors.white;             // White Text
    Color sportAccentColor = const Color(0xFFFF3B30); // Bright Red Buttons

    // --- CURRENT ACTIVE COLORS ---
    Color currentPanelColor = isSport ? sportPanelColor : stockPanelColor;
    Color currentTextColor = isSport ? sportTextColor : stockTextColor;
    Color currentAccentColor = isSport ? sportAccentColor : stockAccentColor;
    Color currentInactiveColor = isSport ? Colors.white38 : Colors.grey[400]!;

    return Scaffold(
      backgroundColor: Colors.white, // Keep image bg white for JPEGs
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              widget.modelName,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              widget.companyName,
              style: TextStyle(color: Colors.grey[500], fontSize: 12, letterSpacing: 1.0),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // --- 1. IMMERSIVE IMAGE AREA ---
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Container(
                  key: ValueKey(getCurrentImagePath()),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(getCurrentImagePath()),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --- 2. DYNAMIC CONTROL PANEL ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: currentPanelColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- VIEW ANGLE SELECTOR ---
                _buildSectionTitle("VIEW ANGLE", currentTextColor),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSport ? Colors.white.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isSport ? null : Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton('Front', _currentView == 'front', currentAccentColor, isSport, () => setState(() => _currentView = 'front')),
                      _buildTabButton('Back', _currentView == 'back', currentAccentColor, isSport, () => setState(() => _currentView = 'back')),
                      _buildTabButton('Interior', _currentView == 'interior', currentAccentColor, isSport, () => setState(() => _currentView = 'interior')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- MODE & COLOR ROW ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MODE SWITCH
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("MODE", currentTextColor),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildModeButton("Stock", false, _packageType == 'stock', currentAccentColor, currentTextColor, currentInactiveColor, () => _updatePackage('stock')),
                              const SizedBox(width: 12),
                              _buildModeButton("Sport", true, _packageType == 'sport', currentAccentColor, currentTextColor, currentInactiveColor, () => _updatePackage('sport')),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // INTERIOR COLORS (Only show if relevant)
                    if (_currentView == 'interior' && isSport) ...[
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("LEATHER", currentTextColor),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildColorCircle(const Color(0xFF682A2A), _interiorColor == 'burgundy', currentAccentColor, () => setState(() => _interiorColor = 'burgundy')), // Burgundy
                                const SizedBox(width: 12),
                                _buildColorCircle(Colors.black, _interiorColor == 'black', currentAccentColor, () => setState(() => _interiorColor = 'black')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionTitle(String title, Color textColor) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: textColor.withOpacity(0.6),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
      child: Text(title),
    );
  }

  Widget _buildTabButton(String text, bool isActive, Color activeColor, bool isSport, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : (isSport ? Colors.white54 : Colors.grey[500]),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, bool isSportBtn, bool isActive, Color activeColor, Color textColor, Color inactiveColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isActive ? activeColor : inactiveColor.withOpacity(0.3),
              width: 1.5
          ),
          boxShadow: isActive ? [BoxShadow(color: activeColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            if (isSportBtn) Icon(Icons.flash_on, color: isActive ? Colors.white : inactiveColor, size: 16),
            if (isSportBtn) const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : inactiveColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color, bool isActive, Color borderColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: isActive ? borderColor : Colors.transparent,
              width: 2
          ),
        ),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
          ),
          child: isActive
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
      ),
    );
  }
}