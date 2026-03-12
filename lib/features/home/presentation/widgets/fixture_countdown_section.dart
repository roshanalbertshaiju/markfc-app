import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'dart:async';

class FixtureCountdownSection extends StatefulWidget {
  const FixtureCountdownSection({super.key});

  @override
  State<FixtureCountdownSection> createState() => _FixtureCountdownSectionState();
}

class _FixtureCountdownSectionState extends State<FixtureCountdownSection> {
  late Timer _timer;
  Duration _timeLeft = const Duration(days: 4, hours: 22, minutes: 47, seconds: 12);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    'MARK INTERNATIONAL v MANCHESTER CITY',
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
                        'OLD TRAFFORD · 14 MAR 2026 · 15:00',
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
