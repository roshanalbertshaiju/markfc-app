import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class LatestNewsSection extends StatelessWidget {
  const LatestNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'LATEST NEWS'),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              ScrollReveal(
                type: AnimationType.fade,
                delay: Duration(milliseconds: 100),
                child: NewsCard(
                  category: 'TRANSFER',
                  title: 'Club Confirms Salah Contract Extension Until 2028',
                  time: '2H AGO',
                  imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=500&q=80',
                ),
              ),
              ScrollReveal(
                type: AnimationType.fade,
                delay: Duration(milliseconds: 200),
                child: NewsCard(
                  category: 'TEAM NEWS',
                  title: 'Nunez Out 2 Weeks With Hamstring Strain',
                  time: '3H AGO',
                  imageUrl: 'https://images.unsplash.com/photo-1543326727-cf6c39e8f84c?w=500&q=80',
                ),
              ),
              ScrollReveal(
                type: AnimationType.fade,
                delay: Duration(milliseconds: 300),
                child: NewsCard(
                  category: 'ACADEMY',
                  title: 'Academy Talents Secure U21 Cup Victory',
                  time: '5H AGO',
                  imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=500&q=80',
                ),
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
  final String time;
  final String imageUrl;

  const NewsCard({
    super.key,
    required this.category,
    required this.title,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16, bottom: 12),
      child: MifcCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.outfit(
                          color: MifcColors.navyBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MifcColors.white,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: MifcColors.white.withValues(alpha: 0.4),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
