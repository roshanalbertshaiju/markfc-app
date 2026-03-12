import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class InlinePollCard extends StatefulWidget {
  const InlinePollCard({super.key});

  @override
  State<InlinePollCard> createState() => _InlinePollCardState();
}

class _InlinePollCardState extends State<InlinePollCard> {
  int _totalVotes = 14382;
  String? _selectedOption;

  final Map<String, int> _options = {
    'M. SALAH': 7478,
    'H. EKITIKE': 4458,
    'J. BELLINGHAM': 2446,
  };

  void _vote(String option) {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = option;
      _options[option] = _options[option]! + 1;
      _totalVotes += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        const Icon(Icons.poll_rounded, color: MifcColors.eliteBlue, size: 14),
                        const SizedBox(width: 10),
                        Text(
                          'SQUAD POLL · MOTM',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: MifcColors.eliteBlue,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_totalVotes.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")} VOTES',
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
                  'WHO WAS YOUR MAN OF THE MATCH?',
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
                  children: _options.entries.map((entry) {
                    final percentage = (entry.value / _totalVotes * 100).round();
                    final isSelected = _selectedOption == entry.key;
                    final isLeading = entry.value == _options.values.reduce((a, b) => a > b ? a : b);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _vote(entry.key),
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
                              width: MediaQuery.of(context).size.width * (percentage / 100),
                              decoration: BoxDecoration(
                                color: isLeading 
                                    ? MifcColors.eliteBlue.withValues(alpha: 0.12) 
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
                                            child: Icon(Icons.check_circle_rounded, color: MifcColors.eliteBlue, size: 16),
                                          ),
                                        Text(
                                          entry.key,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            color: isSelected ? MifcColors.eliteBlue : MifcColors.white.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$percentage%',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isLeading ? MifcColors.eliteBlue : MifcColors.white.withValues(alpha: 0.4),
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
  }
}
