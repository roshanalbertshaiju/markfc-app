import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/mifc_top_bar.dart';
import '../../../../shared/widgets/chat_fab.dart';
import '../../../../core/theme/mifc_colors.dart';

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
      backgroundColor: const Color(0xFF0d1840),
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
      color: const Color(0xFF0d1840),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicatorColor: const Color(0xFFD0021B),
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.45),
        labelStyle: GoogleFonts.barlowCondensed(
          fontSize: 13,
          fontWeight: FontWeight.w800,
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
          const SizedBox(width: 8),
          _buildToggleButton('VIDEOS', showVideos, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFD0021B) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? Colors.transparent : const Color(0xFF1a2760),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.barlowCondensed(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
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
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const FeaturedHeroCard(),
        _buildLatestUpdatesHeader(),
        const HorizontalNewsCard(
          category: 'TRANSFER NEWS',
          categoryColor: Color(0xFFD0021B),
          title: 'Club in talks over summer midfield signing',
          time: '2 hours ago',
          emoji: '🤝',
        ),
        const HorizontalNewsCard(
          category: 'TEAM NEWS',
          categoryColor: Color(0xFF4CAF50),
          title: 'Injury Update: Bellingham returns to full training',
          time: '4 hours ago',
          emoji: '🤕',
        ),
        const FullWidthNewsCard(
          category: 'ACADEMY UPDATES',
          categoryColor: Color(0xFFF5C518),
          title: 'U18s Continue Unbeaten Run With Dominant 4-0 Win',
          excerpt: 'The young Reds showcased their talent with a four-goal display against traditional rivals...',
          time: '6 hours ago',
          imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=800',
        ),
        const HorizontalNewsCard(
          category: 'INTERVIEW',
          categoryColor: Colors.white70,
          title: 'Bellingham: "This squad has the hunger to go all the way"',
          time: '8 hours ago',
          emoji: '🎙️',
        ),
        const HorizontalNewsCard(
          category: 'MATCH REPORT',
          categoryColor: Color(0xFFCE93D8),
          title: 'MIFC 3-1 Arsenal: Player Ratings & Analysis',
          time: 'Yesterday',
          emoji: '📊',
        ),
        const FullWidthNewsCard(
          category: 'CLUB NEWS',
          categoryColor: Colors.white70,
          title: 'New 2025-26 Away Kit Officially Unveiled',
          excerpt: 'The club has pulled back the curtain on the new away strip for next season...',
          time: '2 days ago',
          imageUrl: 'https://images.unsplash.com/photo-1543351611-58f88d736768?q=80&w=800',
        ),
        _buildLoadMoreButton(),
      ],
    );
  }

  Widget _buildLatestUpdatesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'LATEST UPDATES',
            style: GoogleFonts.barlowCondensed(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.tune, color: Color(0xFFD0021B), size: 18),
              const SizedBox(width: 4),
              Text(
                'FILTER',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD0021B),
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
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFD0021B),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'LOAD OLDER STORIES',
          style: GoogleFonts.barlowCondensed(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Colors.white,
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
        VideoCard(
          title: 'Salah Post-Match: "We believe in the title"',
          category: 'INTERVIEW',
          categoryColor: Color(0xFFD0021B),
          duration: '04:20',
          views: '12K views',
          date: '2 hours ago',
          imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=400',
        ),
        VideoCard(
          title: 'Highlights: MIFC 3-1 Arsenal',
          category: 'HIGHLIGHTS',
          categoryColor: MifcColors.navy,
          duration: '10:15',
          views: '45K views',
          date: 'Yesterday',
          imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=400',
        ),
        VideoCard(
          title: 'Behind The Scenes: Training Ground Focus',
          category: 'BTS',
          categoryColor: Colors.teal,
          duration: '06:45',
          views: '8K views',
          date: '2 days ago',
          imageUrl: 'https://images.unsplash.com/photo-1543351611-58f88d736768?q=80&w=400',
        ),
        VideoCard(
          title: 'Manager Press Conference: Liverpool Preview',
          category: 'PRESS',
          categoryColor: Colors.purple,
          duration: '15:30',
          views: '15K views',
          date: '3 days ago',
          imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?q=80&w=400',
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
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Hero(
              tag: 'article_image_1',
              child: CachedNetworkImage(
                imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=1000',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 220,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C518),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '⚡ EXCLUSIVE',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Salah Signs New Deal – Staying Until 2028',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Transfer News • 45 mins ago',
                    style: GoogleFonts.barlow(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
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
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF131e52),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [categoryColor.withOpacity(0.2), categoryColor.withOpacity(0.1)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: categoryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: GoogleFonts.barlow(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.5),
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
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1a2760),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ $category',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: categoryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  excerpt,
                  style: GoogleFonts.barlow(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.barlow(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Read Article',
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD0021B),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Color(0xFFD0021B),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFF131e52),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 150,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned.fill(
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 18,
                    child: Icon(Icons.play_arrow, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$views • $date',
                    style: GoogleFonts.barlow(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
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
