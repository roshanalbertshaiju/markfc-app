import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';

class LatestNewsSection extends StatelessWidget {
  const LatestNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'LATEST NEWS'),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              NewsCard(
                category: 'TRANSFER',
                title: 'Club Confirms Salah Contract Extension Until 2028',
                subtitle: '2 hours ago · Official Announcement',
                color: MifcColors.navy,
                icon: Icons.emoji_events,
              ),
              NewsCard(
                category: 'INJURY',
                title: 'Nunez Out 2 Weeks With Hamstring Strain',
                subtitle: '3 hours ago · Team News',
                color: Colors.green,
                icon: Icons.sentiment_very_dissatisfied,
                isLarge: false,
              ),
              NewsCard(
                category: 'MATCH REPORT',
                title: '3-1 Win vs Arsenal Sends Us 2nd',
                subtitle: 'Yesterday · Match Centre',
                color: MifcColors.navy,
                icon: Icons.sports_soccer,
                isLarge: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final String category;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final bool isLarge;

  const NewsCard({
    super.key,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.isLarge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isLarge ? 280 : 240,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: MifcColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: MifcColors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.barlowCondensed(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(icon, size: 48, color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.barlow(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.navyDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.barlow(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: MifcColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
