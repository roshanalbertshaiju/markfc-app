import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "GOOD MORNING";
    } else if (hour >= 12 && hour < 17) {
      return "GOOD AFTERNOON";
    } else if (hour >= 17 && hour < 21) {
      return "GOOD EVENING";
    } else {
      return "GOOD NIGHT";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/mifc_logo.png',
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 40),
                // Greeting
                Text(
                  _getGreeting(),
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF162460), // Elite Navy Blue
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtext
                Text(
                  "Welcome back",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                "MARK INTERNATIONAL FC",
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[400],
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
