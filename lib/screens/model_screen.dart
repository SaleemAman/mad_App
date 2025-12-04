import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For fetching data
import 'package:flutter/foundation.dart'; // For checking Web vs Mobile
import 'customize_screen.dart';

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

class _ModelScreenState extends State<ModelScreen> with SingleTickerProviderStateMixin {
  List<dynamic> _currentModels = [];
  bool _isLoading = true;
  bool _hasError = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    fetchCarModels();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- API CALL WITH WEB SUPPORT ---
  Future<void> fetchCarModels() async {
    String baseUrl;

    if (kIsWeb) {
      // Chrome/Web ke liye Localhost
      baseUrl = 'http://localhost:3000';
    } else {
      // Android Emulator ke liye 10.0.2.2
      baseUrl = 'http://10.0.2.2:3000';
    }

    final String url = '$baseUrl/api/cars/${widget.companyId}';

    try {
      print("Connecting to: $url");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _currentModels = json.decode(response.body);
          _isLoading = false;
          _hasError = false;
        });
        _controller.forward(); // Start animation when data loads
      } else {
        print("Server Error: ${response.statusCode}");
        setState(() { _hasError = true; _isLoading = false; });
      }
    } catch (e) {
      print("Connection Error: $e");
      setState(() { _hasError = true; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          '${widget.companyName.toUpperCase()} MODELS',
          style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF00E5FF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))) // Cyan Spinner
          : _hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, color: Color(0xFF00E5FF), size: 60),
            const SizedBox(height: 16),
            const Text("Server Disconnected", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchCarModels,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Color(0xFF00E5FF)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("RETRY", style: TextStyle(color: Color(0xFF00E5FF))),
            )
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _currentModels.length,
        itemBuilder: (context, index) {
          final car = _currentModels[index];

          // Animations
          final Animation<double> fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Interval(index * 0.2, 1.0, curve: Curves.easeIn)),
          );
          final Animation<Offset> slideAnim = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller, curve: Interval(index * 0.2, 1.0, curve: Curves.easeOut)),
          );

          return FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _ModelCard(
                  title: car['name']!,
                  subtitle: car['tagline']!,
                  onPressed: () {
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
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const _ModelCard({required this.title, required this.subtitle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5FF).withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF00E5FF), size: 16),
          ],
        ),
      ),
    );
  }
}