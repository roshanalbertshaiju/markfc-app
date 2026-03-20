import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'package:markfc/features/home/data/repositories/poll_repository.dart';
import 'package:markfc/features/home/domain/models/poll.dart';

class MotmPollSection extends ConsumerWidget {
  const MotmPollSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePollAsync = ref.watch(activePollProvider);

    return Column(
      children: [
        const SectionHeader(
          title: 'FAN VOTE', 
          actionLabel: 'ALL POLLS',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: activePollAsync.when(
            data: (poll) {
              if (poll == null) return const SizedBox.shrink();
              
              final sortedOptions = List<PollOption>.from(poll.options)
                ..sort((a, b) => b.votes.compareTo(a.votes));
              
              // Only show top 3 for the section
              final displayOptions = sortedOptions.take(3).toList();
              final leadingVotes = displayOptions.isNotEmpty ? displayOptions.first.votes : 0;

              return ScrollReveal(
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
                            const Icon(Icons.emoji_events_outlined, color: MifcColors.navyBlue, size: 16),
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
                              poll.endsAt != null 
                                ? _getRemainingTime(poll.endsAt!) 
                                : 'LIVE',
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
                              poll.question.toUpperCase(),
                              textAlign: TextAlign.center,
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
                              children: displayOptions.map((opt) {
                                final percentage = poll.totalVotes > 0 
                                    ? (opt.votes / poll.totalVotes * 100).round()
                                    : 0;
                                return PlayerPollColumn(
                                  name: opt.label,
                                  votes: percentage,
                                  isLead: opt.votes == leadingVotes && poll.totalVotes > 0,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 32),
                            _VoteButton(pollId: poll.id, options: poll.options.map((e) => e.label).toList()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  String _getRemainingTime(DateTime endsAt) {
    final diff = endsAt.difference(DateTime.now());
    if (diff.isNegative) return 'ENDED';
    if (diff.inHours > 0) return '${diff.inHours}H REMAINING';
    return '${diff.inMinutes}M REMAINING';
  }
}

class _VoteButton extends ConsumerWidget {
  final String pollId;
  final List<String> options;

  const _VoteButton({required this.pollId, required this.options});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Simple dialog to vote for now, or just vote for the first one for testing
        showModalBottomSheet(
          context: context,
          backgroundColor: MifcColors.card,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VOTE FOR PLAYER OF THE MATCH',
                  style: GoogleFonts.outfit(
                    color: MifcColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                ...options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(opt, style: GoogleFonts.inter(color: MifcColors.white)),
                    trailing: const Icon(Icons.chevron_right, color: MifcColors.navyBlue),
                    onTap: () {
                      ref.read(pollRepositoryProvider).vote(pollId, opt);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Voted for $opt!')),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: MifcColors.white.withValues(alpha: 0.05)),
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
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
              color: (isLead ? MifcColors.navyBlue : MifcColors.white).withValues(alpha: 0.1),
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
                      color: MifcColors.navyBlue,
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
            color: isLead ? MifcColors.navyBlue : MifcColors.white.withValues(alpha: 0.3),
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
                color: isLead ? MifcColors.navyBlue : MifcColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
