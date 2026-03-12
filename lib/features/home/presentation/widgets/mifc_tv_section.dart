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
        const SectionHeader(title: 'MIFC TV', actionLabel: 'WATCH ALL'),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            children: const [
              VideoCard(
                category: 'HIGHLIGHTS',
                duration: '06:32',
                title: 'MIFC 3-1 ARSENAL: THE FULL MATCH STORY',
                views: '142K VIEWS',
                timeAgo: 'YESTERDAY',
              ),
              VideoCard(
                category: 'EXCLUSIVE',
                duration: '18:47',
                title: 'PRE-MATCH ANALYSIS: THE CITY SHOWDOWN',
                views: '38K VIEWS',
                timeAgo: 'TODAY',
              ),
              VideoCard(
                category: 'INSIDE',
                duration: '12:15',
                title: 'BEHIND THE SCENES: SHOOTING PRACTICE',
                views: '28K VIEWS',
                timeAgo: '2 DAYS AGO',
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

  const VideoCard({
    super.key,
    required this.category,
    required this.duration,
    required this.title,
    required this.views,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 154,
            decoration: BoxDecoration(
              color: MifcColors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: MifcColors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Subtle gradient representation of a video thumbnail
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          MifcColors.white.withValues(alpha: 0.02),
                          MifcColors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: MifcColors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.outfit(
                        color: MifcColors.white.withValues(alpha: 0.8),
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: MifcColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: MifcColors.black, size: 24),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Text(
                    duration,
                    style: GoogleFonts.outfit(
                      color: MifcColors.white.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: MifcColors.white,
              letterSpacing: 0.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$views · $timeAgo',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: MifcColors.white.withValues(alpha: 0.3),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
