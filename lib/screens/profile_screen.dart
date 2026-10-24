import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Box settingsBox;

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settings');
  }

  bool get isDarkMode =>
      settingsBox.get('isDarkMode', defaultValue: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // PROFILE HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF4F46E5),
                      Color(0xFF7C3AED),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // AVATAR
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // NAME
                    const Text(
                      'Cash Nova User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // SUBTITLE
                    Text(
                      'v5.3 • Offline Multi-User',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SETTINGS SECTION
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // DARK MODE CARD
              _buildCard(
                child: Row(
                  children: [
                    _iconBox(Icons.dark_mode_rounded),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Switch between light and dark theme',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ✅ FIXED SWITCH (NO ERROR)
                    Switch(
                      value: isDarkMode,
                      activeColor: const Color(0xFF7C3AED),
                      onChanged: (value) async {
                        await settingsBox.put('isDarkMode', value);

                        // UI refresh
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // APP VERSION CARD
              _buildCard(
                child: Row(
                  children: [
                    _iconBox(Icons.verified_rounded),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Version',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Cash Nova v5.3',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2563EB),
                            Color(0xFF7C3AED),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '5.3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // STORAGE CARD
              _buildCard(
                child: Row(
                  children: [
                    _iconBox(Icons.storage_rounded),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Offline Storage',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'All expenses are saved locally on your device',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ABOUT CARD
              _buildCard(
                child: Row(
                  children: [
                    _iconBox(Icons.info_outline_rounded),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Cash Nova',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Premium expense tracker with modern fintech design',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // FOOTER
              Text(
                'Built with Flutter • Hive • Material 3',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  decoration: TextDecoration.none,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Cash Nova v5.3',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // PREMIUM CARD
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  // ICON BOX
  Widget _iconBox(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDBEAFE),
            Color(0xFFEDE9FE),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF2563EB),
        size: 28,
      ),
    );
  }
}