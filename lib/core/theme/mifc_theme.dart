import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mifc_colors.dart';

class MifcTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: MifcColors.navy,
        primary: MifcColors.navy,
        secondary: MifcColors.red,
        surface: MifcColors.surface,
        onSurface: MifcColors.navyDark,
      ),
      scaffoldBackgroundColor: MifcColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: MifcColors.navy,
        foregroundColor: MifcColors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: MifcColors.white,
        indicatorColor: MifcColors.navy.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.barlow(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MifcColors.navy,
            );
          }
          return GoogleFonts.barlow(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: MifcColors.muted,
          );
        }),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.barlowCondensed(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: MifcColors.navyDark,
        ),
        displayMedium: GoogleFonts.barlowCondensed(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: MifcColors.navyDark,
        ),
        headlineLarge: GoogleFonts.barlowCondensed(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: MifcColors.navyDark,
        ),
        headlineMedium: GoogleFonts.barlowCondensed(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: MifcColors.navyDark,
        ),
        titleLarge: GoogleFonts.barlowCondensed(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: MifcColors.navyDark,
        ),
        bodyLarge: GoogleFonts.barlow(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: MifcColors.navyDark,
        ),
        bodyMedium: GoogleFonts.barlow(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MifcColors.navyDark,
        ),
        labelLarge: GoogleFonts.barlowCondensed(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: MifcColors.red,
        ),
      ),
    );
  }
}
