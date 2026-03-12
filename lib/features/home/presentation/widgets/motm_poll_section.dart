import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class MotmPollSection extends StatelessWidget {
  const MotmPollSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(
          title: 'FAN VOTE', 
          actionLabel: 'ALL POLLS',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ScrollReveal(
            type: AnimationType.fade,
            child: MifcCard(
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
                      children: [
                        const Icon(Icons.emoji_events_outlined, color: MifcColors.eliteBlue, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'PLAYER OF THE MATCH',
                          style: GoogleFonts.outfit(
                            color: MifcColors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.timer_outlined, color: MifcColors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '4H REMAINING',
                          style: GoogleFonts.outfit(
                            color: MifcColors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'MIFC 3-1 ARSENAL · 08 MAR 2026',
                          style: GoogleFonts.inter(
                            color: MifcColors.white.withValues(alpha: 0.3),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            PlayerPollColumn(
                              name: 'M. SALAH',
                              votes: 62,
                              isLead: true,
                            ),
                            PlayerPollColumn(
                              name: 'J. BELLINGHAM',
                              votes: 26,
                            ),
                            PlayerPollColumn(
                              name: 'H. EKITIKE',
                              votes: 12,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _VoteButton(),
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
}

class _VoteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: MifcColors.white,
        foregroundColor: MifcColors.black,
        minimumSize: const Size(double.infinity, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        'CAST YOUR VOTE',
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class PlayerPollColumn extends StatelessWidget {
  final String name;
  final int votes;
  final bool isLead;

  const PlayerPollColumn({
    super.key,
    required this.name,
    required this.votes,
    this.isLead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: MifcColors.card.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: (isLead ? MifcColors.eliteBlue : MifcColors.white).withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: MifcColors.white.withValues(alpha: isLead ? 0.8 : 0.2),
                size: 32,
              ),
              if (isLead)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: MifcColors.eliteBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star, color: MifcColors.black, size: 8),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.outfit(
            color: MifcColors.white.withValues(alpha: isLead ? 1.0 : 0.6),
            fontWeight: isLead ? FontWeight.w700 : FontWeight.w500,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$votes%',
          style: GoogleFonts.outfit(
            color: isLead ? MifcColors.eliteBlue : MifcColors.white.withValues(alpha: 0.3),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 2,
          decoration: BoxDecoration(
            color: MifcColors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(1),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: votes / 100,
            child: Container(
              decoration: BoxDecoration(
                color: isLead ? MifcColors.eliteBlue : MifcColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
