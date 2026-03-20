import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/features/fixtures/domain/models/match_model.dart';
import 'package:markfc/features/fixtures/data/repositories/fixtures_repository.dart';

class FixtureCountdownSection extends ConsumerStatefulWidget {
  const FixtureCountdownSection({super.key});

  @override
  ConsumerState<FixtureCountdownSection> createState() => _FixtureCountdownSectionState();
}

class _FixtureCountdownSectionState extends ConsumerState<FixtureCountdownSection> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  MatchModel? _nextMatch;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _nextMatch != null) {
        setState(() {
          _timeLeft = _nextMatch!.timestamp.difference(DateTime.now());
          if (_timeLeft.isNegative) {
            _timeLeft = Duration.zero;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fixturesAsync = ref.watch(fixturesStreamProvider);

    return fixturesAsync.when(
      data: (fixtures) {
        // Find the next upcoming match
        final now = DateTime.now();
        final upcomingMatches = fixtures
            .where((m) => m.timestamp.isAfter(now))
            .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

        if (upcomingMatches.isEmpty) {
          return const SizedBox.shrink();
        }

        final nextMatch = upcomingMatches.first;
        if (_nextMatch?.id != nextMatch.id) {
          _nextMatch = nextMatch;
          _timeLeft = _nextMatch!.timestamp.difference(now);
        }

        return _buildContent(context, nextMatch);
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(BuildContext context, MatchModel match) {
    return Column(
      children: [
        const SectionHeader(title: 'NEXT FIXTURE'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ScrollReveal(
            type: AnimationType.fade,
            child: MifcCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountdownBlock(_timeLeft.inDays.toString().padLeft(2, '0'), 'DAYS'),
                      _buildDivider(),
                      _buildCountdownBlock((_timeLeft.inHours % 24).toString().padLeft(2, '0'), 'HOURS'),
                      _buildDivider(),
                      _buildCountdownBlock((_timeLeft.inMinutes % 60).toString().padLeft(2, '0'), 'MINUTES'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '${match.homeTeam.toUpperCase()} v ${match.awayTeam.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: MifcColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined, color: MifcColors.white.withValues(alpha: 0.3), size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${match.venue.toUpperCase()} · ${DateFormat('dd MMM yyyy · HH:mm').format(match.timestamp)}',
                        style: GoogleFonts.inter(
                          color: MifcColors.white.withValues(alpha: 0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _TicketButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildCountdownBlock(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: MifcColors.white,
            fontSize: 42,
            fontWeight: FontWeight.w300,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: MifcColors.white.withValues(alpha: 0.3),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Text(
        ':',
        style: GoogleFonts.outfit(
          color: MifcColors.white.withValues(alpha: 0.1),
          fontSize: 24,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}

class _TicketButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: MifcColors.crimson,
        foregroundColor: MifcColors.white,
        minimumSize: const Size(double.infinity, 50),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        'SECURE TICKETS',
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
