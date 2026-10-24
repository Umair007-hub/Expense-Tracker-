import 'package:flutter/material.dart';

class PremiumSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        IconData icon = Icons.check_circle_rounded,

        // 🎨 DEFAULT HATKE COLOR
        Color color = const Color(0xFF0EA5E9), // cyan blue
      }) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutBack,
            tween: Tween(begin: -120, end: 0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },

            // 🔥 PREMIUM NOTIFICATION CARD
            child: Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                // 🌈 HATKE GRADIENT (Dashboard se alag)
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF06B6D4), // Cyan
                    Color(0xFF0891B2), // Teal
                    Color(0xFF059669), // Emerald
                  ],
                ),

                // 🧊 Glass Border
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1,
                ),

                // ✨ Glow Shadow
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.35),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: const Color(0xFF059669).withOpacity(0.18),
                    blurRadius: 40,
                    spreadRadius: 1,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),

              child: Row(
                children: [
                  // 🎯 Icon Container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.22),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // 📝 Message
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ✖ Close
                  GestureDetector(
                    onTap: () => entry.remove(),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // ⏱️ AUTO DISMISS - 10 SECOND
    Future.delayed(const Duration(seconds: 3), () {
      try {
        entry.remove();
      } catch (_) {
        // already removed
      }
    });
  }
}