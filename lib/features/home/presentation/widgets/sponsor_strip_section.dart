import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';

class SponsorStripSection extends StatelessWidget {
  const SponsorStripSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      color: MifcColors.white,
      child: Column(
        children: [
          Text(
            'OUR PARTNERS',
            style: GoogleFonts.barlowCondensed(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: MifcColors.muted.withOpacity(0.5),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 24),
                _buildSponsorLogo('Adidas'),
                _buildSponsorLogo('Fly Emirates'),
                _buildSponsorLogo('TeamViewer'),
                _buildSponsorLogo('Cadbury'),
                _buildSponsorLogo('Standard Chartered'),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorLogo(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Opacity(
        opacity: 0.4,
        child: Column(
          children: [
            Icon(Icons.business, color: MifcColors.muted, size: 32),
            const SizedBox(height: 4),
            Text(
              name.toUpperCase(),
              style: GoogleFonts.barlowCondensed(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: MifcColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
