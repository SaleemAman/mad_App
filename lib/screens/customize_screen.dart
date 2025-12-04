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

class _CustomizeScreenState extends State<CustomizeScreen> with SingleTickerProviderStateMixin {
  String _currentView = 'front';
  String _packageType = 'stock';
  String _interiorColor = 'beige';
  late AnimationController _controller;
  late Animation<double> _panelAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _panelAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getCurrentImagePath() {
    String basePath = 'assets/images/${widget.companyName.toLowerCase()}/${widget.folderName}/';
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
      if (newPackage == 'stock') _interiorColor = 'beige';
      else if (_interiorColor == 'beige') _interiorColor = 'burgundy';
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSport = _packageType == 'sport';

    // THEME COLORS (Consistent Navy & Cyan)
    Color panelColor = const Color(0xFF0F172A);
    Color accentColor = const Color(0xFF00E5FF);

    return Scaffold(
      backgroundColor: Colors.white, // Image background keeps white for JPGs
      appBar: AppBar(
        elevation: 0,
        backgroundColor: panelColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: accentColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(widget.modelName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text("CUSTOMIZER", style: TextStyle(color: accentColor, fontSize: 10, letterSpacing: 2.0)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. IMAGE AREA
          Expanded(
            child: InteractiveViewer(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Image.asset(
                  getCurrentImagePath(),
                  key: ValueKey(getCurrentImagePath()),
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                ),
              ),
            ),
          ),

          // 2. CONTROL PANEL (Sliding Up)
          SizeTransition(
            sizeFactor: _panelAnim,
            axisAlignment: -1.0,
            child: Container(
              decoration: BoxDecoration(
                color: panelColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                border: Border(top: BorderSide(color: accentColor.withOpacity(0.5), width: 1)), // Cyan Top Border
                boxShadow: [BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("VIEW ANGLE", accentColor),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: accentColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton('Front', _currentView == 'front', accentColor, () => setState(() => _currentView = 'front')),
                        _buildTabButton('Back', _currentView == 'back', accentColor, () => setState(() => _currentView = 'back')),
                        _buildTabButton('Interior', _currentView == 'interior', accentColor, () => setState(() => _currentView = 'interior')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("MODE", accentColor),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildModeButton("Stock", false, !isSport, accentColor, () => _updatePackage('stock')),
                                const SizedBox(width: 12),
                                _buildModeButton("Sport", true, isSport, accentColor, () => _updatePackage('sport')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (_currentView == 'interior' && isSport) ...[
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("LEATHER", accentColor),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildColorCircle(const Color(0xFF682A2A), _interiorColor == 'burgundy', accentColor, () => setState(() => _interiorColor = 'burgundy')),
                                  const SizedBox(width: 12),
                                  _buildColorCircle(Colors.black, _interiorColor == 'black', accentColor, () => setState(() => _interiorColor = 'black')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(title, style: TextStyle(color: color.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5));
  }

  Widget _buildTabButton(String text, bool active, Color color, VoidCallback tap) {
    return Expanded(
      child: GestureDetector(
        onTap: tap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: TextStyle(color: active ? Colors.black : Colors.white54, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, bool isSportBtn, bool active, Color color, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? color : Colors.white24, width: 1.5),
          boxShadow: active ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10)] : [],
        ),
        child: Row(
          children: [
            if (isSportBtn) Icon(Icons.flash_on, color: active ? color : Colors.white54, size: 16),
            if (isSportBtn) const SizedBox(width: 4),
            Text(text, style: TextStyle(color: active ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color circleColor, bool active, Color borderColor, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: active ? borderColor : Colors.transparent, width: 2),
          boxShadow: active ? [BoxShadow(color: borderColor.withOpacity(0.4), blurRadius: 8)] : [],
        ),
        child: Container(width: 28, height: 28, decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle)),
      ),
    );
  }
}