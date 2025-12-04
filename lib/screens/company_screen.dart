import 'package:flutter/material.dart';
import 'model_screen.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Background
      appBar: AppBar(
        title: const Text(
          'SELECT BRAND',
          style: TextStyle(
            color: Color(0xFF00E5FF), // Cyan Title
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF00E5FF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          // Staggered Animation: Har item thodi der baad aayega
          final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval((1 / companies.length) * index, 1.0, curve: Curves.easeOut),
            ),
          );

          final Animation<Offset> slideAnim = Tween<Offset>(begin: const Offset(0.5, 0.0), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval((1 / companies.length) * index, 1.0, curve: Curves.easeOut),
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideAnim,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B), // Card BG
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.5), width: 1.5), // Cyan Border
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.15), // Cyan Glow
                      blurRadius: 15,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                    ),
                    child: Image.asset(
                      companies[index]['logo']!,
                      width: 40,
                      height: 40,
                      errorBuilder: (c, e, s) => const Icon(Icons.car_repair, color: Colors.white),
                    ),
                  ),
                  title: Text(
                    companies[index]['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF00E5FF)),
                  onTap: () {
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
              ),
            ),
          );
        },
      ),
    );
  }
}