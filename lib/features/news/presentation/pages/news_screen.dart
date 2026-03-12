import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/mifc_top_bar.dart';
import '../../../../shared/widgets/chat_fab.dart';
import '../../../../core/theme/mifc_colors.dart';
import '../../../../shared/widgets/mifc_card.dart';
import '../../../../shared/widgets/scroll_reveal.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showVideos = false;

  final List<String> _categories = [
    'All News', 'Transfers', 'Team', 'Academy', 'Interviews', 'Match Reports'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MifcColors.black,
      appBar: const MifcTopBar(),
      floatingActionButton: const ChatFab(),
      body: Column(
        children: [
          CategoryTabBar(controller: _tabController, categories: _categories),
          ArticlesVideosToggle(
            showVideos: _showVideos,
            onChanged: (val) => setState(() => _showVideos = val),
          ),
          Expanded(
            child: _showVideos ? const VideoListTab() : const NewsScrollBody(),
          ),
        ],
      ),
    );
  }
}

class CategoryTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> categories;

  const CategoryTabBar({super.key, required this.controller, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: MifcColors.black,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicatorColor: MifcColors.crimson,
        indicatorWeight: 2,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
        labelColor: MifcColors.white,
        unselectedLabelColor: MifcColors.white.withValues(alpha: 0.3),
        labelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        tabs: categories.map((cat) => Tab(text: cat.toUpperCase())).toList(),
      ),
    );
  }
}

class ArticlesVideosToggle extends StatelessWidget {
  final bool showVideos;
  final ValueChanged<bool> onChanged;

  const ArticlesVideosToggle({super.key, required this.showVideos, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          _buildToggleButton('ARTICLES', !showVideos, () => onChanged(false)),
          const SizedBox(width: 12),
          _buildToggleButton('VIDEOS', showVideos, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? MifcColors.white.withValues(alpha: 0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? MifcColors.white.withValues(alpha: 0.1) : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? MifcColors.white : MifcColors.white.withValues(alpha: 0.4),
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class NewsScrollBody extends StatelessWidget {
  const NewsScrollBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      physics: const BouncingScrollPhysics(),
      children: [
        const ScrollReveal(
          type: AnimationType.fade,
          child: FeaturedHeroCard(),
        ),
        _buildLatestUpdatesHeader(),
        const ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 100),
          child: HorizontalNewsCard(
            category: 'TRANSFER NEWS',
            categoryColor: MifcColors.crimson,
            title: 'CLUB IN TALKS OVER SUMMER MIDFIELD SIGNING',
            time: '2 HOURS AGO',
            emoji: '🤝',
          ),
        ),
        const ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 200),
          child: HorizontalNewsCard(
            category: 'TEAM NEWS',
            categoryColor: Colors.greenAccent,
            title: 'INJURY UPDATE: BELLINGHAM RETURNS TO FULL TRAINING',
            time: '4 HOURS AGO',
            emoji: '🤕',
          ),
        ),
        const ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 300),
          child: FullWidthNewsCard(
            category: 'ACADEMY UPDATES',
            categoryColor: MifcColors.eliteBlue,
            title: 'U18S CONTINUE UNBEATEN RUN WITH DOMINANT 4-0 WIN',
            excerpt: 'The young Reds showcased their talent with a four-goal display against traditional rivals at the academy grounds this morning...',
            time: '6 HOURS AGO',
            imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=800',
          ),
        ),
        const ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 400),
          child: HorizontalNewsCard(
            category: 'INTERVIEW',
            categoryColor: Colors.white70,
            title: 'BELLINGHAM: "THIS SQUAD HAS THE HUNGER TO GO ALL THE WAY"',
            time: '8 HOURS AGO',
            emoji: '🎙️',
          ),
        ),
        const ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 500),
          child: HorizontalNewsCard(
            category: 'MATCH REPORT',
            categoryColor: Colors.purpleAccent,
            title: 'MIFC 3-1 ARSENAL: PLAYER RATINGS & ANALYSIS',
            time: 'YESTERDAY',
            emoji: '📊',
          ),
        ),
        const ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 600),
          child: FullWidthNewsCard(
            category: 'CLUB NEWS',
            categoryColor: Colors.white70,
            title: 'NEW 2025-26 AWAY KIT OFFICIALLY UNVEILED',
            excerpt: 'The club has pulled back the curtain on the new away strip for next season, featuring a bold monochrome aesthetic...',
            time: '2 DAYS AGO',
            imageUrl: 'https://images.unsplash.com/photo-1543351611-58f88d736768?q=80&w=800',
          ),
        ),
        const SizedBox(height: 16),
        _buildLoadMoreButton(),
      ],
    );
  }

  Widget _buildLatestUpdatesHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'LATEST UPDATES',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MifcColors.white.withValues(alpha: 0.4),
              letterSpacing: 1.5,
            ),
          ),
          Row(
            children: [
              Icon(Icons.tune, color: MifcColors.white.withValues(alpha: 0.4), size: 14),
              const SizedBox(width: 6),
              Text(
                'FILTER',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: MifcColors.white.withValues(alpha: 0.4),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MifcCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'LOAD OLDER STORIES',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MifcColors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class VideoListTab extends StatelessWidget {
  const VideoListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 100),
          child: VideoCard(
            title: 'SALAH POST-MATCH: "WE BELIEVE IN THE TITLE"',
            category: 'INTERVIEW',
            categoryColor: MifcColors.crimson,
            duration: '04:20',
            views: '12K VIEWS',
            date: '2 HOURS AGO',
            imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=400',
          ),
        ),
        ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 200),
          child: VideoCard(
            title: 'HIGHLIGHTS: MIFC 3-1 ARSENAL',
            category: 'HIGHLIGHTS',
            categoryColor: Colors.blueAccent,
            duration: '10:15',
            views: '45K VIEWS',
            date: 'YESTERDAY',
            imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=400',
          ),
        ),
        ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 300),
          child: VideoCard(
            title: 'BEHIND THE SCENES: TRAINING GROUND FOCUS',
            category: 'BTS',
            categoryColor: Colors.tealAccent,
            duration: '06:45',
            views: '8K VIEWS',
            date: '2 DAYS AGO',
            imageUrl: 'https://images.unsplash.com/photo-1543351611-58f88d736768?q=80&w=400',
          ),
        ),
        ScrollReveal(
          type: AnimationType.fade,
          delay: Duration(milliseconds: 400),
          child: VideoCard(
            title: 'MANAGER PRESS CONFERENCE: LIVERPOOL PREVIEW',
            category: 'PRESS',
            categoryColor: Colors.purpleAccent,
            duration: '15:30',
            views: '15K VIEWS',
            date: '3 DAYS AGO',
            imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?q=80&w=400',
          ),
        ),
      ],
    );
  }
}

class FeaturedHeroCard extends StatelessWidget {
  const FeaturedHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news/article/1'),
      child: Container(
        height: 280,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            Hero(
              tag: 'article_image_1',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 280,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    MifcColors.black.withValues(alpha: 0.9),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: MifcColors.crimson,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'EXCLUSIVE',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: MifcColors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TRANSFER NEWS',
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: MifcColors.white.withValues(alpha: 0.5),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SALAH SIGNS NEW DEAL: STAYING UNTIL 2028',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      height: 1.1,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '45 MINUTES AGO',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: MifcColors.white.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalNewsCard extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final String title;
  final String time;
  final String emoji;

  const HorizontalNewsCard({
    super.key,
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.time,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news/article/pending'),
      child: MifcCard(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: MifcColors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: categoryColor.withValues(alpha: 0.8),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: MifcColors.white.withValues(alpha: 0.3),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullWidthNewsCard extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final String title;
  final String excerpt;
  final String time;
  final String imageUrl;

  const FullWidthNewsCard({
    super.key,
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.excerpt,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news/article/pending'),
      child: MifcCard(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: categoryColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    excerpt,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: MifcColors.white.withValues(alpha: 0.4),
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: MifcColors.white.withValues(alpha: 0.2),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'READ FULL STORY',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: MifcColors.eliteBlue,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: MifcColors.eliteBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String title;
  final String category;
  final Color categoryColor;
  final String duration;
  final String views;
  final String date;
  final String imageUrl;

  const VideoCard({
    super.key,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.duration,
    required this.views,
    required this.date,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Handle video play
      child: MifcCard(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 140,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MifcColors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: MifcColors.black, size: 20),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: MifcColors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      duration,
                      style: GoogleFonts.outfit(
                        color: MifcColors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.outfit(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: categoryColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$views · $date',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: MifcColors.white.withValues(alpha: 0.3),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
