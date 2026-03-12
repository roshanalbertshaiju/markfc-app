import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/mifc_colors.dart';

class InlinePollCard extends StatefulWidget {
  const InlinePollCard({super.key});

  @override
  State<InlinePollCard> createState() => _InlinePollCardState();
}

class _InlinePollCardState extends State<InlinePollCard> {
  int _totalVotes = 14382;
  String? _selectedOption;

  final Map<String, int> _options = {
    'M. Salah': 7478,
    'Ekitike': 4458,
    'Bellingham': 2446,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: MifcColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MifcColors.gold.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: MifcColors.gold.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.poll_outlined, color: MifcColors.gold, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'QUICK POLL · MOTM',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: MifcColors.gold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_totalVotes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VOTES',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: MifcColors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          // Question
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Who was Man of the Match?',
              style: GoogleFonts.barlowCondensed(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          // Options
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: _options.entries.map((entry) {
                final percentage = (entry.value / _totalVotes * 100).round();
                final isSelected = _selectedOption == entry.key;
                final isLeading = entry.value == _options.values.reduce((a, b) => a > b ? a : b);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => _vote(entry.key),
                    child: Stack(
                      children: [
                        // Progress Background
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Progress Fill
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          height: 44,
                          width: MediaQuery.of(context).size.width * (percentage / 100),
                          decoration: BoxDecoration(
                            color: isLeading 
                                ? MifcColors.gold.withOpacity(0.15) 
                                : Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Label & Percentage
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (isSelected) 
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(Icons.check_circle, color: MifcColors.gold, size: 14),
                                      ),
                                    Text(
                                      entry.key,
                                      style: GoogleFonts.barlowCondensed(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '$percentage%',
                                  style: GoogleFonts.barlowCondensed(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: isLeading ? MifcColors.gold : Colors.white.withOpacity(0.4),
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
    );
  }
}
