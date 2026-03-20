import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:intl/intl.dart'; // Unused
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'package:markfc/features/news/data/repositories/news_repository.dart';
import 'package:markfc/features/news/domain/models/news_article.dart';

class LatestNewsSection extends ConsumerWidget {
  const LatestNewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the latest 5 news articles
    final newsAsyncValue = ref.watch(latestNewsProvider(5));

    return Column(
      children: [
        const SectionHeader(title: 'LATEST NEWS'),
        SizedBox(
          height: 240,
          child: newsAsyncValue.when(
            data: (articles) {
              if (articles.isEmpty) {
                return Center(
                  child: Text(
                    'No news available',
                    style: GoogleFonts.inter(color: Colors.white54),
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return ScrollReveal(
                    type: AnimationType.fade,
                    delay: Duration(milliseconds: (index + 1) * 100),
                    child: NewsCard(article: article),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: MifcColors.navyBlue),
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load news',
                    style: GoogleFonts.inter(color: MifcColors.crimson),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => ref.refresh(latestNewsProvider(5)),
                    icon: const Icon(Icons.refresh, size: 16, color: Colors.white70),
                    label: Text(
                      'Retry',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  const NewsCard({
    super.key,
    required this.article,
  });

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}D AGO';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}H AGO';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}M AGO';
    } else {
      return 'JUST NOW';
    }
  }

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
                  CachedNetworkImage(
                    imageUrl: article.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: MifcColors.navyBlue,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image_not_supported, 
                            color: Colors.white24, size: 24),
                          const SizedBox(height: 4),
                          Image.asset(
                        'assets/images/mifc_logo.png',
                        height: 20,
                        color: Colors.white.withValues(alpha: 0.5),
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                        ],
                      ),
                    ),
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
                        article.category.toUpperCase(),
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
                      article.title,
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
                      _formatTime(article.timestamp),
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
