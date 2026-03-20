import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/features/home/data/repositories/poll_repository.dart';
// import 'package:markfc/features/home/domain/models/poll.dart'; // Unused
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class InlinePollCard extends ConsumerStatefulWidget {
  const InlinePollCard({super.key});

  @override
  ConsumerState<InlinePollCard> createState() => _InlinePollCardState();
}

class _InlinePollCardState extends ConsumerState<InlinePollCard> {
  String? _selectedOption;

  void _vote(String pollId, String option) {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = option;
    });
    ref.read(pollRepositoryProvider).vote(pollId, option);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('VOTED FOR $option!'),
        backgroundColor: MifcColors.navyBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePollAsync = ref.watch(activePollProvider);

    return activePollAsync.when(
      data: (poll) {
        if (poll == null) return const SizedBox.shrink();

        return ScrollReveal(
          type: AnimationType.fade,
          child: MifcCard(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            color: MifcColors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: MifcColors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: MifcColors.white.withValues(alpha: 0.03),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.poll_rounded, color: MifcColors.navyBlue, size: 14),
                            const SizedBox(width: 10),
                            Text(
                              'SQUAD POLL · MOTM',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: MifcColors.navyBlue,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${poll.totalVotes.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")} VOTES',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: MifcColors.white.withValues(alpha: 0.3),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Question
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Text(
                      poll.question.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MifcColors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  // Options
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      children: poll.options.map((opt) {
                        final percentage = poll.totalVotes > 0 
                            ? (opt.votes / poll.totalVotes * 100).round()
                            : 0;
                        final isSelected = _selectedOption == opt.label;
                        final isLeading = poll.totalVotes > 0 && 
                            opt.votes == poll.options.map((e) => e.votes).reduce((a, b) => a > b ? a : b);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _vote(poll.id, opt.label),
                            child: Stack(
                              children: [
                                // Progress Background
                                Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: MifcColors.white.withValues(alpha: 0.03),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: MifcColors.white.withValues(alpha: 0.05)),
                                  ),
                                ),
                                // Progress Fill
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeOutQuart,
                                  height: 52,
                                  width: poll.totalVotes > 0 
                                      ? (MediaQuery.of(context).size.width - 72) * (percentage / 100)
                                      : 0,
                                  decoration: BoxDecoration(
                                    color: isLeading 
                                        ? MifcColors.navyBlue.withValues(alpha: 0.12) 
                                        : MifcColors.white.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                // Label & Percentage
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (isSelected) 
                                              const Padding(
                                                padding: EdgeInsets.only(right: 12),
                                                child: Icon(Icons.check_circle_rounded, color: MifcColors.navyBlue, size: 16),
                                              ),
                                            Text(
                                              opt.label,
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                                color: isSelected ? MifcColors.navyBlue : MifcColors.white.withValues(alpha: 0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '$percentage%',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: isLeading ? MifcColors.navyBlue : MifcColors.white.withValues(alpha: 0.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: MifcColors.navyBlue),
        ),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

