import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _logoController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ringController.dispose();
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // OUTER ROTATING RING
          AnimatedBuilder(
            animation: _ringController,
            builder: (_, __) {
              return Transform.rotate(
                angle: _ringController.value * 2 * math.pi,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        const Color(0xFF2563EB).withOpacity(0.1),
                        const Color(0xFF7C3AED).withOpacity(0.8),
                        const Color(0xFF06B6D4).withOpacity(0.8),
                        const Color(0xFF2563EB).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // INNER GLOW
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) {
              return Container(
                width: 170 + (_pulseController.value * 10),
                height: 170 + (_pulseController.value * 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2563EB)
                      .withOpacity(0.08 + (_pulseController.value * 0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB)
                          .withOpacity(0.25 + (_pulseController.value * 0.1)),
                      blurRadius: 40 + (_pulseController.value * 10),
                      spreadRadius: 5 + (_pulseController.value * 2),
                    ),
                  ],
                ),
              );
            },
          ),

          // LOGO SCALE + FADE
          AnimatedBuilder(
            animation: _logoController,
            builder: (_, child) {
              return Transform.scale(
                scale: Curves.easeOutBack.transform(_logoController.value),
                child: Opacity(
                  opacity: _logoController.value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x552563EB),
                    blurRadius: 30,
                    spreadRadius: 4,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}