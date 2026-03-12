import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import '../widgets/discussion/discussion_section.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String id;

  const ArticleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MifcColors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildArticleHeader(),
                      const SizedBox(height: 32),
                      _buildArticleBody(),
                    ],
                  ),
                ),
                const DiscussionSection(),
                const SizedBox(height: 120), // Space for input bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: MifcColors.black,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MifcColors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: MifcColors.white, size: 16),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MifcColors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share_outlined, color: MifcColors.white, size: 18),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'article_image_$id',
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000',
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      MifcColors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                      MifcColors.black.withValues(alpha: 0.8),
                      MifcColors.black,
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),
            ],
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: MifcColors.crimson,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'TRANSFER NEWS',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: MifcColors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'SALAH SIGNS NEW DEAL: STAYING UNTIL 2028',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: MifcColors.white,
            height: 1.1,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: MifcColors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, color: MifcColors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BY MARKFC EDITORIAL',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: MifcColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'MARCH 12, 2026 • 4 MIN READ',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: MifcColors.white.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
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
      style: GoogleFonts.inter(
        fontSize: 16,
        color: MifcColors.white.withValues(alpha: 0.7),
        height: 1.8,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
      ),
    );
  }
}

