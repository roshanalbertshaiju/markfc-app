import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';

class MotmPollSection extends StatelessWidget {
  const MotmPollSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'FAN VOTE', actionText: 'ALL POLLS'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: MifcColors.navyDark,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: MifcColors.red,
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'MAN OF THE MATCH',
                        style: GoogleFonts.barlowCondensed(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Closes in 4h',
                        style: GoogleFonts.barlowCondensed(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'MIFC 3 - 1 Arsenal · Premier League · 08 Mar 2026',
                        style: GoogleFonts.barlowCondensed(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          PlayerPollColumn(
                            name: 'M. Salah',
                            number: '11',
                            votes: 62,
                            isLead: true,
                          ),
                          PlayerPollColumn(
                            name: 'Bellingham',
                            number: '8',
                            votes: 26,
                          ),
                          PlayerPollColumn(
                            name: 'Ekitike',
                            number: '22',
                            votes: 12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MifcColors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'VOTE NOW & EARN +50 PTS',
                          style: GoogleFonts.barlowCondensed(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
}

class PlayerPollColumn extends StatelessWidget {
  final String name;
  final String number;
  final int votes;
  final bool isLead;

  const PlayerPollColumn({
    super.key,
    required this.name,
    required this.number,
    required this.votes,
    this.isLead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                color: isLead ? MifcColors.navy : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: isLead
                    ? Border.all(color: MifcColors.gold.withOpacity(0.5), width: 1)
                    : null,
              ),
              child: Opacity(
                opacity: 0.1,
                child: Center(
                  child: Text(
                    number,
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (isLead)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.workspace_premium, color: MifcColors.gold, size: 16),
              ),
            const Icon(Icons.person, color: Colors.white, size: 40),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: GoogleFonts.barlowCondensed(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: votes / 100,
            child: Container(
              decoration: BoxDecoration(
                color: isLead ? MifcColors.gold : MifcColors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$votes%',
          style: GoogleFonts.barlowCondensed(
            color: isLead ? MifcColors.gold : Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
