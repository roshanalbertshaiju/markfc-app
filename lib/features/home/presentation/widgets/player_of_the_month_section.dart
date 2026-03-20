import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/features/home/data/repositories/awards_repository.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class PlayerOfTheMonthSection extends ConsumerWidget {
  const PlayerOfTheMonthSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final potmAsync = ref.watch(potmStreamProvider);

    return Column(
      children: [
        const SectionHeader(title: 'PLAYER OF THE MONTH'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: potmAsync.when(
            data: (potm) {
              if (potm == null) return const SizedBox.shrink();

              return ScrollReveal(
                type: AnimationType.fade,
                child: MifcCard(
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      // Subtle accent gradient
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                MifcColors.white.withValues(alpha: 0.05),
                                MifcColors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    potm.month.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      color: MifcColors.navyBlue,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    potm.name.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      color: MifcColors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${potm.position.toUpperCase()} · ${potm.appearances} APPEARANCES',
                                    style: GoogleFonts.inter(
                                      color: MifcColors.white.withValues(alpha: 0.4),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 80,
                              color: MifcColors.white.withValues(alpha: 0.05),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatRow('GOALS', potm.goals.toString().padLeft(2, '0')),
                                  const SizedBox(height: 16),
                                  _buildStatRow('ASSISTS', potm.assists.toString().padLeft(2, '0')),
                                  const SizedBox(height: 16),
                                  _buildStatRow('RATING', potm.rating.toStringAsFixed(1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(height: 150, child: Center(child: CircularProgressIndicator(color: MifcColors.navyBlue))),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: MifcColors.white.withValues(alpha: 0.3),
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: MifcColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

