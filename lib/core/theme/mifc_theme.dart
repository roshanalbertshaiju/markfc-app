import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mifc_colors.dart';

class MifcTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: MifcColors.navyBlue,
        secondary: MifcColors.crimson,
        surface: MifcColors.black,
        onSurface: MifcColors.white,
      ),
      scaffoldBackgroundColor: MifcColors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: MifcColors.black,
        foregroundColor: MifcColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: MifcColors.black,
        indicatorColor: MifcColors.navyBlue.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? MifcColors.navyBlue : MifcColors.muted,
            letterSpacing: 0.5,
          );
        }),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: MifcColors.white,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: MifcColors.white,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: MifcColors.white,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: MifcColors.white,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: MifcColors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: MifcColors.white,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MifcColors.white.withValues(alpha: 0.7),
          height: 1.4,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MifcColors.navyBlue,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
