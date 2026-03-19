import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'package:markfc/features/fixtures/data/repositories/fixtures_repository.dart';
import 'package:markfc/features/fixtures/domain/models/match_model.dart';

class MatchCentreSection extends ConsumerWidget {
  const MatchCentreSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveMatchAsync = ref.watch(liveMatchStreamProvider);
    final resultsAsync = ref.watch(resultsStreamProvider);

    return Column(
      children: [
        const SectionHeader(title: 'MATCH CENTRE', actionLabel: 'ALL RESULTS'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              liveMatchAsync.when(
                data: (match) {
                  if (match == null) return const SizedBox.shrink();
                  return ScrollReveal(
                    type: AnimationType.fade,
                    delay: const Duration(milliseconds: 100),
                    child: _buildLiveScoreCard(match),
                  );
                },
                loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                error: (err, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              resultsAsync.when(
                data: (results) {
                  if (results.isEmpty) return const SizedBox.shrink();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: results.length > 3 ? 3 : results.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final match = results[index];
                      final resultChar = _getResultChar(match);
                      return ScrollReveal(
                        type: AnimationType.fade,
                        delay: Duration(milliseconds: 200 + (index * 100)),
                        child: _buildPreviousResult(
                          DateFormat('dd MMM').format(match.timestamp),
                          match.homeTeam,
                          match.awayTeam,
                          '${match.homeScore} - ${match.awayScore}',
                          resultChar,
                        ),
                      );
                    },
                  );
                },
                loading: () => const SizedBox(height: 50, child: Center(child: CircularProgressIndicator())),
                error: (err, stack) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getResultChar(MatchModel match) {
    // Assuming 'MARK International FC' is always the team we track
    const ourTeam = 'MARK INTERNATIONAL FC';
    final bool isHome = match.homeTeam.toUpperCase() == ourTeam;
    
    if (match.homeScore == match.awayScore) return 'D';
    if (isHome) {
      return match.homeScore > match.awayScore ? 'W' : 'L';
    } else {
      return match.awayScore > match.homeScore ? 'W' : 'L';
    }
  }

  Widget _buildLiveScoreCard(MatchModel match) {
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
                  match.competition.toUpperCase(),
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
                    if (match.liveMinute != null) ...[
                      const SizedBox(width: 12),
                      Text(
                        "${match.liveMinute}'",
                        style: GoogleFonts.outfit(
                          color: MifcColors.navyBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
                _buildTeamInfo(match.homeCode, match.homeTeam, match.homeTeam.toUpperCase().contains('MARK')),
                Column(
                  children: [
                    Text(
                      '${match.homeScore} - ${match.awayScore}',
                      style: GoogleFonts.outfit(
                        fontSize: 42,
                        fontWeight: FontWeight.w300,
                        color: MifcColors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    if (match.scorers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        match.scorers.join(', '),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: MifcColors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ],
                ),
                _buildTeamInfo(match.awayCode, match.awayTeam, match.awayTeam.toUpperCase().contains('MARK')),
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
          name.toUpperCase(),
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
