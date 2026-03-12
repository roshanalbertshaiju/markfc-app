import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';

class MifcTvSection extends StatelessWidget {
  const MifcTvSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'MIFC TV', actionText: 'WATCH ALL'),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              VideoCard(
                category: 'HIGHLIGHTS',
                duration: '6:32',
                title: 'MIFC 3-1 Arsenal - All Goals & Key Moments',
                views: '142k views',
                timeAgo: 'Yesterday',
                color: MifcColors.navy,
              ),
              VideoCard(
                category: 'PRESS',
                duration: '18:47',
                title: 'Pre-Match: Ready for Man City Showdown',
                views: '38k views',
                timeAgo: 'Today',
                color: Colors.purple,
              ),
              VideoCard(
                category: 'BTS',
                duration: '12:15',
                title: 'Inside Training: Shooting Practice',
                views: '28k views',
                timeAgo: '2 days ago',
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VideoCard extends StatelessWidget {
  final String category;
  final String duration;
  final String title;
  final String views;
  final String timeAgo;
  final Color color;

  const VideoCard({
    super.key,
    required this.category,
    required this.duration,
    required this.title,
    required this.views,
    required this.timeAgo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
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
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: MifcColors.navy, size: 28),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      duration,
                      style: GoogleFonts.barlowCondensed(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.barlowCondensed(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: MifcColors.navyDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$views · $timeAgo',
            style: GoogleFonts.barlow(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: MifcColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
