import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
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
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: MifcColors.navyDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCountdownBlock(_timeLeft.inDays.toString().padLeft(2, '0'), 'DAYS'),
                    _buildDivider(),
                    _buildCountdownBlock((_timeLeft.inHours % 24).toString().padLeft(2, '0'), 'HOURS'),
                    _buildDivider(),
                    _buildCountdownBlock((_timeLeft.inMinutes % 60).toString().padLeft(2, '0'), 'MINS'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'MARK INTERNATIONAL v MANCHESTER CITY',
                  style: GoogleFonts.barlowCondensed(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: MifcColors.gold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'OLD TRAFFORD · 14 MAR 2026 · 15:00',
                      style: GoogleFonts.barlowCondensed(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.confirmation_num, size: 18),
                  label: Text(
                    'GET TICKETS - FROM £35',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MifcColors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildCountdownBlock(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            value,
            style: GoogleFonts.barlowCondensed(
              color: MifcColors.gold,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.barlowCondensed(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
      child: Text(
        ':',
        style: GoogleFonts.barlowCondensed(
          color: Colors.white.withOpacity(0.2),
          fontSize: 32,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
