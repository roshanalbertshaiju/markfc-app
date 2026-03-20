import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/features/home/data/repositories/awards_repository.dart';
// import 'package:markfc/features/home/domain/models/fan_of_the_month.dart'; // Unused
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class FanOfTheMonthSection extends ConsumerWidget {
  const FanOfTheMonthSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fotmAsync = ref.watch(fotmStreamProvider);

    return Column(
      children: [
        const SectionHeader(title: 'FAN OF THE MONTH', actionLabel: 'NOMINATE'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: fotmAsync.when(
            data: (fotm) {
              if (fotm == null) return const SizedBox.shrink();

              return ScrollReveal(
                type: AnimationType.fade,
                child: MifcCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: MifcColors.card.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MifcColors.navyBlue.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            fotm.initials.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: MifcColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_outline, color: MifcColors.navyBlue, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  '${fotm.month.toUpperCase()} RECIPIENT',
                                  style: GoogleFonts.outfit(
                                    color: MifcColors.navyBlue,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fotm.name.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: MifcColors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'MIFC SUPPORTER SINCE ${fotm.supporterSince} · TIER ${fotm.tier.toUpperCase()}',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: MifcColors.white.withValues(alpha: 0.3),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildStatBlock(fotm.matchesAttended.toString(), 'MATCHES'),
                                const SizedBox(width: 24),
                                _buildStatBlock(fotm.points, 'POINTS'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: MifcColors.navyBlue))),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBlock(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MifcColors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: MifcColors.white.withValues(alpha: 0.2),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

