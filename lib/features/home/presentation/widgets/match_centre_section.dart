import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class MatchCentreSection extends StatelessWidget {
  const MatchCentreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'MATCH CENTRE', actionLabel: 'ALL RESULTS'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ScrollReveal(
                type: AnimationType.fade,
                delay: const Duration(milliseconds: 100),
                child: _buildLiveScoreCard(),
              ),
              const SizedBox(height: 12),
              ScrollReveal(
                type: AnimationType.fade,
                delay: const Duration(milliseconds: 200),
                child: _buildPreviousResult('08 MAR', 'Mark International FC', 'Arsenal FC', '3 - 1', 'W'),
              ),
              const SizedBox(height: 8),
              ScrollReveal(
                type: AnimationType.fade,
                delay: const Duration(milliseconds: 300),
                child: _buildPreviousResult('02 MAR', 'Chelsea FC', 'Mark International FC', '2 - 2', 'D'),
              ),
              const SizedBox(height: 8),
              ScrollReveal(
                type: AnimationType.fade,
                delay: const Duration(milliseconds: 400),
                child: _buildPreviousResult('24 FEB', 'Mark International FC', 'Everton FC', '4 - 0', 'W'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveScoreCard() {
    return MifcCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: MifcColors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PREMIER LEAGUE · MATCHWEEK 28',
                  style: GoogleFonts.outfit(
                    color: MifcColors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                Row(
                  children: [
                    const PulsingDot(),
                    const SizedBox(width: 8),
                    Text(
                      'LIVE',
                      style: GoogleFonts.outfit(
                        color: MifcColors.crimson,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "72'",
                      style: GoogleFonts.outfit(
                        color: MifcColors.navyBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamInfo('MIFC', 'MARK FC', true),
                Column(
                  children: [
                    Text(
                      '3 - 1',
                      style: GoogleFonts.outfit(
                        fontSize: 42,
                        fontWeight: FontWeight.w300,
                        color: MifcColors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildScorerChip('Salah 12\', 71\''),
                        const SizedBox(width: 8),
                        _buildScorerChip('Ekitike 47\''),
                      ],
                    ),
                  ],
                ),
                _buildTeamInfo('ARS', 'ARSENAL', false),
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
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: MifcColors.card.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: (isHome ? MifcColors.crimson : MifcColors.white).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              code,
              style: GoogleFonts.outfit(
                color: MifcColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: MifcColors.white.withValues(alpha: 0.8),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildScorerChip(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: MifcColors.white.withValues(alpha: 0.4),
      ),
    );
  }

  Widget _buildPreviousResult(String date, String home, String away, String score, String result) {
    Color resultColor = MifcColors.white.withValues(alpha: 0.4);
    if (result == 'W') resultColor = const Color(0xFF4CAF50);
    if (result == 'L') resultColor = MifcColors.crimson;

    return MifcCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              date.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: MifcColors.white.withValues(alpha: 0.3),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    home.toUpperCase(),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: MifcColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    score,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    away.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: MifcColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: resultColor.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Text(
                result,
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: resultColor,
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
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: MifcColors.crimson,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
