import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/mifc_colors.dart';

class ReactionsBar extends StatefulWidget {
  const ReactionsBar({super.key});

  @override
  State<ReactionsBar> createState() => _ReactionsBarState();
}

class _ReactionsBarState extends State<ReactionsBar> {
  final Map<String, int> _counts = {
    '🔥': 1200,
    '👏': 847,
    '💙': 1100,
    '😮': 234,
    '😂': 156,
    '❤️': 923,
  };

  final Set<String> _userReactions = {};

  void _toggleReaction(String emoji) {
    setState(() {
      if (_userReactions.contains(emoji)) {
        _userReactions.remove(emoji);
        _counts[emoji] = _counts[emoji]! - 1;
      } else {
        _userReactions.add(emoji);
        _counts[emoji] = _counts[emoji]! + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = _counts.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'REACT TO THIS ARTICLE',
            style: GoogleFonts.barlowCondensed(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: MifcColors.mutedOpacity,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _counts.entries.map((entry) {
              return ReactionPill(
                emoji: entry.key,
                count: entry.value,
                isActive: _userReactions.contains(entry.key),
                maxCount: maxCount,
                onTap: () => _toggleReaction(entry.key),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ReactionPill extends StatelessWidget {
  final String emoji;
  final int count;
  final bool isActive;
  final int maxCount;
  final VoidCallback onTap;

  const ReactionPill({
    super.key,
    required this.emoji,
    required this.count,
    required this.isActive,
    required this.maxCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color? borderColor;
    Color countColor = Colors.white;

    // Tier system
    if (isActive) {
      bgColor = MifcColors.gold.withOpacity(0.12);
      borderColor = MifcColors.gold;
      countColor = MifcColors.gold;
    } else if (count >= 1000) {
      bgColor = MifcColors.red.withOpacity(0.15);
      borderColor = MifcColors.red;
      countColor = MifcColors.red;
    } else if (count >= 500) {
      bgColor = MifcColors.gold.withOpacity(0.1);
      borderColor = MifcColors.gold;
    } else {
      bgColor = MifcColors.cardLight;
      borderColor = null;
    }

    final String displayCount = count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}k' : '$count';
    final double progress = maxCount > 0 ? count / maxCount : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      displayCount,
                      key: ValueKey(count),
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: countColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Progress bar
              Container(
                height: 2,
                width: 30, // Base width for consistency
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive || count >= 500 ? MifcColors.gold : MifcColors.muted,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
