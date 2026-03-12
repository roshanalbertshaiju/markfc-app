import 'package:flutter/material.dart';

class MifcColors {
  // Brand Base
  static const Color navyDark = Color(0xFF0d1840);
  static const Color navy = Color(0xFF162460);
  static const Color navyLight = Color(0xFF1e3280);
  static const Color red = Color(0xFFD0021B);
  static const Color gold = Color(0xFFF5C518);
  
  // Surface & Layout
  static const Color dartsurface = Color(0xFF0d1840);
  static const Color surface = Color(0xFFF2F4FB);
  static const Color card = Color(0xFF131e52);
  static const Color cardLight = Color(0xFF1a2760);
  
  // Content & Feedback
  static const Color muted = Color(0xFF5C6389);
  static const Color border = Color(0x14FFFFFF); // 8% white
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Derived Opacities (Helpful for design requirements)
  static Color mutedOpacity = Colors.white.withOpacity(0.45);
}
