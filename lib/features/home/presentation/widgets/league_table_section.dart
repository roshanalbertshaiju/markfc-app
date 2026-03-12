import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class LeagueTableSection extends StatelessWidget {
  const LeagueTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'LEAGUE TABLE', actionLabel: 'FULL TABLE'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ScrollReveal(
            type: AnimationType.fade,
            child: MifcCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: MifcColors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'PREMIER LEAGUE 2025-26',
                          style: GoogleFonts.outfit(
                            color: MifcColors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'WEEK 28',
                          style: GoogleFonts.outfit(
                            color: MifcColors.navyBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildRow(1, 'LIV', 'LIVERPOOL', 28, 59, ['W', 'W', 'W', 'D', 'L']),
                        _buildRow(2, 'MIFC', 'MARK INTERNATIONAL', 28, 56, ['W', 'W', 'W', 'D', 'W'], isHighlighted: true),
                        _buildRow(3, 'MNC', 'MANCHESTER CITY', 28, 54, ['D', 'W', 'L', 'W', 'W']),
                        _buildRow(4, 'ARS', 'ARSENAL', 28, 52, ['W', 'W', 'D', 'W', 'W']),
                        _buildRow(5, 'CHE', 'CHELSEA', 28, 48, ['W', 'W', 'W', 'W', 'D']),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          const SizedBox(width: 24),
          const Expanded(child: SizedBox()),
          _buildHeaderText('P'),
          _buildHeaderText('PTS', isLast: true),
          const SizedBox(width: 80), // Space for form dots
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text, {bool isLast = false}) {
    return SizedBox(
      width: isLast ? 40 : 30,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          color: MifcColors.white.withValues(alpha: 0.3),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildRow(int pos, String code, String name, int p, int pts, List<String> form, {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isHighlighted ? MifcColors.crimson.withValues(alpha: 0.05) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$pos',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w400,
                color: isHighlighted ? MifcColors.crimson : MifcColors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                color: isHighlighted ? MifcColors.white : MifcColors.white.withValues(alpha: 0.8),
                letterSpacing: 0.5,
              ),
            ),
          ),
          _buildDataText('$p'),
          _buildDataText('$pts', isBold: true, isLast: true),
          const SizedBox(width: 12),
          _buildFormDots(form),
        ],
      ),
    );
  }

  Widget _buildDataText(String text, {bool isBold = false, bool isLast = false}) {
    return SizedBox(
      width: isLast ? 40 : 30,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          color: isBold ? MifcColors.white : MifcColors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildFormDots(List<String> form) {
    return Row(
      children: form.map((res) {
        Color color = MifcColors.white.withValues(alpha: 0.05);
        if (res == 'W') color = const Color(0xFF4CAF50).withValues(alpha: 0.4);
        if (res == 'L') color = MifcColors.crimson.withValues(alpha: 0.4);
        
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: res == 'W' || res == 'L' 
                ? Border.all(color: color.withValues(alpha: 1.0), width: 0.5)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
