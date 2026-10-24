import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/animated_logo.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _textController.forward();
    });

    // ⏱️ 3.2 SECOND TOTAL SPLASH
    Timer(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (_, __, ___) =>
            const MainNavigationScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF111827),
              Color(0xFF020617),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating light orbs
            Positioned(
              top: -120,
              right: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7C3AED).withOpacity(0.18),
                ),
              ),
            ),

            Positioned(
              bottom: -140,
              left: -100,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2563EB).withOpacity(0.16),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AnimatedLogo(),

                  const SizedBox(height: 32),

                  FadeTransition(
                    opacity: _textAnimation,
                    child: const Column(
                      children: [
                        Text(
                          'Cash Nova',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Track • Control • Grow',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 56),

                  // Premium loading
                  SizedBox(
                    width: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF06B6D4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Version badge
            Positioned(
              bottom: 34,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: const Text(
                    'v5.3',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
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