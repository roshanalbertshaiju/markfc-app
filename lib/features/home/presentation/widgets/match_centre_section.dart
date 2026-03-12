import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';

class MatchCentreSection extends StatelessWidget {
  const MatchCentreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'MATCH CENTRE', actionText: 'ALL RESULTS'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildLiveScoreCard(),
              const SizedBox(height: 12),
              _buildPreviousResult('08 MAR', 'Mark International FC', 'Arsenal FC', '3 - 1', 'W'),
              const SizedBox(height: 8),
              _buildPreviousResult('02 MAR', 'Chelsea FC', 'Mark International FC', '2 - 2', 'D'),
              const SizedBox(height: 8),
              _buildPreviousResult('24 FEB', 'Mark International FC', 'Everton FC', '4 - 0', 'W'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveScoreCard() {
    return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: MifcColors.navyDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PREMIER LEAGUE · GW28',
                  style: GoogleFonts.barlowCondensed(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    const PulsingDot(),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: GoogleFonts.barlowCondensed(
                        color: MifcColors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '72\'',
                      style: GoogleFonts.barlowCondensed(
                        color: MifcColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTeamInfo('MIFC', 'Mark\nInternational', true),
                    Text(
                      '3 - 1',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: MifcColors.navyDark,
                      ),
                    ),
                    _buildTeamInfo('ARS', 'Arsenal\nFC', false),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScorerChip('Salah 12\', 71\''),
                    const SizedBox(width: 8),
                    _buildScorerChip('Ekitike 47\''),
                    const SizedBox(width: 12),
                    _buildScorerChip('Trossard 34\'', isHome: false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(String code, String name, bool isHome) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isHome ? MifcColors.navy : MifcColors.red,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              code,
              style: GoogleFonts.barlowCondensed(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.barlowCondensed(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: MifcColors.navyDark,
          ),
        ),
      ],
    );
  }

  Widget _buildScorerChip(String text, {bool isHome = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHome ? MifcColors.surface : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sports_soccer, size: 10, color: MifcColors.muted),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.barlow(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: MifcColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousResult(String date, String home, String away, String score, String result) {
    Color resultCode = Colors.green;
    if (result == 'D') resultCode = Colors.orange;
    if (result == 'L') resultCode = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: MifcColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date.split(' ')[0],
                style: GoogleFonts.barlowCondensed(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: MifcColors.muted,
                ),
              ),
              Text(
                date.split(' ')[1],
                style: GoogleFonts.barlowCondensed(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: MifcColors.muted.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  home,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: MifcColors.navyDark,
                  ),
                ),
                Text(
                  away,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: MifcColors.navyDark,
                  ),
                ),
              ],
            ),
          ),
          Text(
            score.split(' ')[0],
            style: GoogleFonts.barlowCondensed(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: MifcColors.navyDark,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: resultCode.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                result,
                style: GoogleFonts.barlowCondensed(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: resultCode,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key});

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: MifcColors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
