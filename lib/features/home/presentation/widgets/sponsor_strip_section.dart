import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';

class SponsorStripSection extends StatelessWidget {
  const SponsorStripSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      color: Colors.transparent,
      child: Column(
        children: [
          Text(
            'OUR PARTNERS',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: MifcColors.white.withValues(alpha: 0.2),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 48),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                const SizedBox(width: 32),
                _buildSponsorLogo('ADIDAS'),
                _buildSponsorLogo('EMIRATES'),
                _buildSponsorLogo('TEAMVIEWER'),
                _buildSponsorLogo('CADBURY'),
                _buildSponsorLogo('STANDARD CHARTERED'),
                const SizedBox(width: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorLogo(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Opacity(
        opacity: 0.15,
        child: Column(
          children: [
            const Icon(Icons.business_center_outlined, color: MifcColors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              name,
              style: GoogleFonts.outfit(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: MifcColors.white,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
