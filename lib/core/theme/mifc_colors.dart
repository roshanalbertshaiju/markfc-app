import 'package:flutter/material.dart';

class MifcColors {
  // Brand Base - Sophisticated Monochrome & Metal
  static const Color black = Color(0xFF0A0A0A);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color deepCharcoal = Color(0xFF111111);
  
  // Accents - Precious Metals & Sartorial Tones
  static const Color crimson = Color(0xFF9D1C1E); // Sartorial Crimson
  static const Color navyBlue = Color(0xFF162460); // Elite Navy Blue
  static const Color palladium = Color(0xFFD1D1D1); // Palladium Silver

  // Surface & Layout
  static const Color surface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF0F0F0F);
  static const Color card = Color(0xFF161616);
  static const Color glass = Color(0x1AFFFFFF); // 10% White for glassmorphism

  // Content & Feedback
  static const Color muted = Color(0xFF888888);
  static const Color border = Color(0x0FFFFFFF); // 6% white
  static const Color white = Color(0xFFFFFFFF);

  static Color mutedOpacity = Colors.white.withValues(alpha: 0.3);

  // Legacy Mappings (Temporary to keep app building during migration)
  static const Color navyDark = black;
  static const Color navy = charcoal;
  static const Color red = crimson;
  static const Color gold = navyBlue;
  static const Color champagne = navyBlue;
  static const Color eliteBlue = navyBlue;
  static const Color dartsurface = darkSurface;
  static const Color cardLight = charcoal;
}
