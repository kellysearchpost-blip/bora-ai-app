import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:bora_ai/auth_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get total device width to scale typography perfectly
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16), // Premium Deep Black/Cyan background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. TOP HEADER NAVIGATION BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'BORA AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AuthScreen()),
                            );
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AuthScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981), // Bora Accent Green
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Start Free',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 2. LIVE STATUS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.globe, color: Color(0xFF10B981), size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'Now live across Africa • AI online',
                        style: TextStyle(
                          color: Colors.green[300],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 3. RESPONSIVE MAIN HEADLINE
                Text(
                  "Africa's\nIntelligence\nEngine",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.105, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),

                // 4. SUBHEADLINE / DESCRIPTION PARAGRAPH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Learn. Build. Grow. Innovate. Bora AI helps students, entrepreneurs, healthcare professionals, farmers, and organizations unlock the power of artificial intelligence - built for Africa.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 5. RESPONSIVE METRICS GRID
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(LucideIcons.globe2, color: Color(0xFF10B981), size: 22),
                            const SizedBox(height: 8),
                            const Text(
                              '54',
                              style: TextStyle(color: Color(0xFF10B981), fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'African Countries',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                      
                      Container(height: 35, width: 1, color: const Color(0xFF1E293B)),

                      Expanded(
                        child: Column(
                          children: [
                            const Icon(LucideIcons.languages, color: Color(0xFF10B981), size: 22),
                            const SizedBox(height: 8),
                            const Text(
                              '500+',
                              style: TextStyle(color: Color(0xFF10B981), fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Languages Supported',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.3),
                            ),
                          ],
                        ),
                      ),

                      Container(height: 35, width: 1, color: const Color(0xFF1E293B)),

                      Expanded(
                        child: Column(
                          children: [
                            const Icon(LucideIcons.layoutGrid, color: Color(0xFF10B981), size: 22),
                            const SizedBox(height: 8),
                            const Text(
                              '12+',
                              style: TextStyle(color: Color(0xFF10B981), fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AI Modules',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // 6. BOTTOM CALL-TO-ACTION BUTTONS
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Start Free',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(LucideIcons.arrowRight, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Try Bora AI',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}