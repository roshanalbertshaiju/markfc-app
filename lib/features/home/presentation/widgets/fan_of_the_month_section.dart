import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';

class FanOfTheMonthSection extends StatelessWidget {
  const FanOfTheMonthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'FAN OF THE MONTH', actionText: 'NOMINATE'),
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
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 140,
                  color: MifcColors.navyDark,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: MifcColors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'AJ',
                              style: GoogleFonts.barlowCondensed(
                                color: MifcColors.navyDark,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          top: -2,
                          child: Icon(Icons.workspace_premium, color: MifcColors.gold, size: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: MifcColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'FEBRUARY 2026 WINNER',
                              style: GoogleFonts.barlowCondensed(
                                color: MifcColors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Adebayo James',
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: MifcColors.navyDark,
                          ),
                        ),
                        Text(
                          'Supporting MIFC since 2019 · Member #04821',
                          style: GoogleFonts.barlow(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: MifcColors.muted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatBlock('42', 'MATCHES'),
                            const SizedBox(width: 8),
                            _buildStatBlock('Gold', 'TIER'),
                            const SizedBox(width: 8),
                            _buildStatBlock('6.7k', 'POINTS'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBlock(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: MifcColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.barlowCondensed(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: MifcColors.navyDark,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.barlowCondensed(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: MifcColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
