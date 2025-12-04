import 'package:flutter/material.dart';
import 'company_screen.dart';
import 'dart:math';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // --- ANIMATIONS ---
  late Animation<Offset> _saloShakeAnim; // Shake effect
  late Animation<Offset> _modsSlideAnim; // MODS nikalne ke liye
  late Animation<double> _modsFadeAnim;  // MODS dikhai dene ke liye
  late Animation<double> _circleProgressAnim; // Circle draw karne ke liye
  late Animation<double> _buttonFadeAnim; // Button aane ke liye

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000), // 3 Seconds ka simple intro
      vsync: this,
    );

    // 1. SALO SHAKE (0.5 sec wait, phir shake)
    _saloShakeAnim = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(5, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(5, 0), end: const Offset(-5, 0)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: const Offset(-5, 0), end: const Offset(5, 0)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: const Offset(5, 0), end: Offset.zero), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.3, curve: Curves.easeInOut),
    ));

    // 2. MODS REVEAL (Right side se slide out)
    _modsSlideAnim = Tween<Offset>(
      begin: const Offset(-0.5, 0.0), // SALO ke peeche
      end: const Offset(0.0, 0.0),    // Apni jagah par
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.5, curve: Curves.easeOutBack),
    ));

    _modsFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.4, curve: Curves.easeIn),
      ),
    );

    // 3. CIRCLE DRAWING
    _circleProgressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
      ),
    );

    // 4. BUTTON FADE IN
    _buttonFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
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
      backgroundColor: const Color(0xFF0F172A),
      body: Center( // Sab kuch CENTER mein
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- LOGO AREA (TEXT + CIRCLE) ---
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. THE TEXT (SALO + MODS)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "SALO" (Shakes)
                      AnimatedBuilder(
                        animation: _saloShakeAnim,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: _saloShakeAnim.value,
                            child: const Text(
                              'SALO',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Roboto',
                                color: Color(0xFF00E5FF), // Cyan Color
                                letterSpacing: 2.0,
                              ),
                            ),
                          );
                        },
                      ),

                      // "MODS" (Slides out)
                      AnimatedBuilder(
                        animation: Listenable.merge([_modsSlideAnim, _modsFadeAnim]),
                        builder: (context, child) {
                          return Opacity(
                            opacity: _modsFadeAnim.value,
                            child: Transform.translate(
                              offset: _modsSlideAnim.value,
                              child: const Text(
                                'MODS',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Roboto',
                                  color: Color(0xFF00E5FF), // Cyan Color
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // 2. THE CIRCLE (Draws around text)
                  AnimatedBuilder(
                    animation: _circleProgressAnim,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(280, 280),
                        painter: CirclePainter(
                          progress: _circleProgressAnim.value,
                          color: const Color(0xFF00E5FF),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30), // Thoda gap

            // --- CONTINUE BUTTON ---
            // Moved down as requested
            FadeTransition(
              opacity: _buttonFadeAnim,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0), // Added padding to move it down
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CompanyScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A), // Dark bg
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                      side: const BorderSide(color: Color(0xFF00E5FF), width: 1.5), // Cyan Border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CUSTOM PAINTER FOR LOGO CIRCLE ---
class CirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  CirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2; // Full width radius

    // Draw OUTER Arc (Full Circle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at top
      2 * pi * progress, // Sweep angle
      false,
      paint,
    );

    // Draw INNER Arcs (Cut where text is)
    // Only draw if animation has progressed enough
    if (progress > 0.5) {
      final Paint innerPaint = Paint()
        ..color = color.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      double innerRadius = radius * 0.75;
      double gapAngle = pi / 4; // Gap size (45 degrees approx)

      // Draw TOP Arc (Cut Left and Right)
      // Starts from Top-Rightish and goes to Top-Leftish
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        -pi + gapAngle, // Start from Left gap
        (pi - 2 * gapAngle) * ((progress - 0.5) * 2), // Sweep across top
        false,
        innerPaint,
      );

      // Draw BOTTOM Arc (Cut Left and Right)
      // Starts from Bottom-Rightish and goes to Bottom-Leftish
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        gapAngle, // Start from Right gap
        (pi - 2 * gapAngle) * ((progress - 0.5) * 2), // Sweep across bottom
        false,
        innerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}