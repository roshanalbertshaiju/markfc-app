import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';

class LeagueTableSection extends StatelessWidget {
  const LeagueTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'LEAGUE TABLE', actionText: 'FULL TABLE'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: MifcColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: MifcColors.navy,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'PREMIER LEAGUE 2025-26',
                        style: GoogleFonts.barlowCondensed(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'GW28',
                        style: GoogleFonts.barlowCondensed(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
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
                      const Divider(height: 1),
                      _buildRow(1, 'LIV', 'Liverpool', 28, 18, 5, 5, 59, ['W', 'W', 'W', 'D', 'L']),
                      _buildRow(2, 'MIFC', 'Mark Intl FC', 28, 17, 5, 6, 56, ['W', 'W', 'W', 'D', 'W'], isHighlighted: true),
                      _buildRow(3, 'MNC', 'Man City', 28, 16, 6, 6, 54, ['D', 'W', 'L', 'W', 'W']),
                      _buildRow(4, 'ARS', 'Arsenal', 28, 15, 7, 6, 52, ['W', 'W', 'D', 'W', 'W']),
                      _buildRow(5, 'CHE', 'Chelsea', 28, 14, 6, 8, 48, ['W', 'W', 'W', 'W', 'D']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 24),
          const SizedBox(width: 32),
          const Expanded(child: SizedBox()),
          _buildHeaderText('P'),
          _buildHeaderText('W'),
          _buildHeaderText('D'),
          _buildHeaderText('L'),
          _buildHeaderText('PTS', isLast: true),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text, {bool isLast = false}) {
    return SizedBox(
      width: isLast ? 45 : 30,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.barlowCondensed(
          color: MifcColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildRow(int pos, String code, String name, int p, int w, int d, int l, int pts, List<String> form, {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isHighlighted ? MifcColors.surface.withOpacity(0.5) : null,
        border: isHighlighted
            ? const Border(left: BorderSide(color: MifcColors.red, width: 3))
            : null,
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          SizedBox(
            width: 20,
            child: Text(
              '$pos',
              style: GoogleFonts.barlowCondensed(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: MifcColors.navyDark,
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isHighlighted ? MifcColors.navy : MifcColors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                code[0],
                style: GoogleFonts.barlowCondensed(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.barlowCondensed(
                fontSize: 14,
                fontWeight: isHighlighted ? FontWeight.w900 : FontWeight.w700,
                color: MifcColors.navyDark,
              ),
            ),
          ),
          _buildDataText('$p'),
          _buildDataText('$w'),
          _buildDataText('$d'),
          _buildDataText('$l'),
          _buildDataText('$pts', isBold: true, isLast: true),
          const SizedBox(width: 8),
          _buildFormDots(form),
          const SizedBox(width: 16),
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
        style: GoogleFonts.barlowCondensed(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
          color: MifcColors.navyDark,
        ),
      ),
    );
  }

  Widget _buildFormDots(List<String> form) {
    return Row(
      children: form.map((res) {
        Color color = Colors.green;
        if (res == 'D') color = Colors.orange;
        if (res == 'L') color = Colors.red;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }
}
