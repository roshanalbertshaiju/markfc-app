import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/mifc_colors.dart';
import '../widgets/news_articles_tab.dart'; // To reuse HorizontalNewsCard
import '../widgets/discussion/discussion_section.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String id;

  const ArticleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1840),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildArticleHeader(),
                      const SizedBox(height: 24),
                      _buildArticleBody(),
                    ],
                  ),
                ),
                const DiscussionSection(),
                const SizedBox(height: 100), // Space for input bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF0d1840),
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.black26,
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.black26,
            child: Icon(Icons.share, color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'article_image_$id',
          child: CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFD0021B),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'TRANSFER NEWS',
            style: GoogleFonts.barlowCondensed(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Salah Signs New Deal – Staying Until 2028',
          style: GoogleFonts.barlowCondensed(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white54, size: 14),
            const SizedBox(width: 6),
            Text(
              'March 12, 2026 • 4 min read',
              style: GoogleFonts.barlow(
                fontSize: 13,
                color: Colors.white54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleBody() {
    return Text(
      'Mark International Football Club is delighted to announce that Mohamed Salah has signed a new long-term contract with the club.\n\n'
      'The Egyptian forward, who has become a living legend at Old Trafford, has committed his future to the Reds until at least 2028.\n\n'
      'Since joining the club, Salah has broken numerous records and played a pivotal role in our recent silverware successes. His dedication, professionalism, and world-class talent continue to inspire fans and teammates alike.\n\n'
      '"I am so happy to continue my journey with this amazing club," Salah said. "We have built something special here, and I want to help the team win even more trophies in the coming years. The fans have always been incredible, and I want to give them my best every single day."',
      style: GoogleFonts.barlow(
        fontSize: 16,
        color: Colors.white.withOpacity(0.9),
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
