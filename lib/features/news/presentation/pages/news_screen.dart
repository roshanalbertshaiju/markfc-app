import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/mifc_top_bar.dart';
import '../../../../shared/widgets/chat_fab.dart';
import '../../../../core/theme/mifc_colors.dart';
import '../../../../shared/widgets/mifc_card.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import 'package:markfc/features/news/data/repositories/news_repository.dart';
import 'package:markfc/features/news/domain/models/video_content.dart';
import 'package:markfc/features/news/data/repositories/video_repository.dart';
import 'package:markfc/features/news/domain/models/news_article.dart';

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

class NewsScrollBody extends ConsumerWidget {
  const NewsScrollBody({super.key});

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} DAYS AGO';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} HOURS AGO';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} MINUTES AGO';
    } else {
      return 'JUST NOW';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsyncValue = ref.watch(latestNewsProvider(20));

    return newsAsyncValue.when(
      data: (articles) {
        if (articles.isEmpty) {
          return Center(
            child: Text(
              'NO NEWS ARTICLES FOUND',
              style: GoogleFonts.outfit(color: Colors.white54, letterSpacing: 1.5),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40),
          physics: const BouncingScrollPhysics(),
          itemCount: articles.length + 2, // + Featured Hero + Header
          itemBuilder: (context, index) {
            if (index == 0) {
              return ScrollReveal(
                type: AnimationType.fade,
                child: FeaturedHeroCard(article: articles[0]),
              );
            }
            if (index == 1) {
              return _buildLatestUpdatesHeader();
            }

            final articleIndex = index - 1; // Adjust for Hero card at 0
            if (articleIndex >= articles.length) {
                // This could be the load more button if we implement pagination
                return _buildLoadMoreButton();
            }
            
            final article = articles[articleIndex];
            final displayTime = _formatTime(article.timestamp);

            // Alternate between HorizontalNewsCard and FullWidthNewsCard for variety
            if (articleIndex % 3 == 0 && articleIndex != 0) {
              return ScrollReveal(
                type: AnimationType.fade,
                delay: const Duration(milliseconds: 100),
                child: FullWidthNewsCard(
                  article: article,
                  displayTime: displayTime,
                ),
              );
            }

            return ScrollReveal(
              type: AnimationType.fade,
              delay: const Duration(milliseconds: 100),
              child: HorizontalNewsCard(
                article: article,
                displayTime: displayTime,
                emoji: _getEmojiForCategory(article.category),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: MifcColors.navyBlue)),
      error: (err, stack) => Center(child: Text('Error loading news: $err')),
    );
  }

  String _getEmojiForCategory(String category) {
    switch (category.toUpperCase()) {
      case 'TRANSFER':
      case 'TRANSFERS':
        return '🤝';
      case 'TEAM':
      case 'TEAM NEWS':
        return '🤕';
      case 'ACADEMY':
        return '🏆';
      case 'INTERVIEW':
        return '🎙️';
      case 'MATCH REPORT':
        return '📊';
      default:
        return '🗞️';
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: MifcCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'END OF NEWS FEED',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MifcColors.white.withValues(alpha: 0.5),
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class VideoListTab extends ConsumerWidget {
  const VideoListTab({super.key});

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M VIEWS';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K VIEWS';
    } else {
      return '$views VIEWS';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM yyyy').format(timestamp).toUpperCase();
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} DAYS AGO';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} HOURS AGO';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} MINUTES AGO';
    } else {
      return 'JUST NOW';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(allVideosProvider);

    return videosAsync.when(
      data: (videos) {
        if (videos.isEmpty) {
          return const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white70)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return ScrollReveal(
              type: AnimationType.fade,
              delay: Duration(milliseconds: 100 + (index * 50)),
              child: VideoCard(
                video: video,
                displayViews: _formatViews(video.views),
                displayTime: _formatTime(video.timestamp),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('Error loading videos', style: TextStyle(color: Colors.white70))),
    );
  }
}

class FeaturedHeroCard extends StatelessWidget {
  final NewsArticle article;
  const FeaturedHeroCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news/article/${article.id}'),
      child: Container(
        height: 280,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            Hero(
              tag: 'article_image_${article.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 280,
                  errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
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
                          'FEATURED',
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
                        article.category.toUpperCase(),
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
                    article.title.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      height: 1.1,
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
  final NewsArticle article;
  final String displayTime;
  final String emoji;

  const HorizontalNewsCard({
    super.key,
    required this.article,
    required this.displayTime,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news/article/${article.id}'),
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
                    article.category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.navyBlue.withValues(alpha: 0.8),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.title.toUpperCase(),
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
                    displayTime,
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
  final NewsArticle article;
  final String displayTime;

  const FullWidthNewsCard({
    super.key,
    required this.article,
    required this.displayTime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news/article/${article.id}'),
      child: MifcCard(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.crimson,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayTime,
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
                              color: MifcColors.navyBlue,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: MifcColors.navyBlue,
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
  final VideoContent video;
  final String displayViews;
  final String displayTime;

  const VideoCard({
    super.key,
    required this.video,
    required this.displayViews,
    required this.displayTime,
  });

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'INTERVIEW':
        return MifcColors.crimson;
      case 'HIGHLIGHTS':
        return MifcColors.navyBlue;
      case 'TRAINING':
        return MifcColors.prestigeGold;
      default:
        return MifcColors.white.withValues(alpha: 0.5);
    }
  }

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
                    imageUrl: video.imageUrl,
                    width: 140,
                    height: 90,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, err) => Container(color: Colors.white10),
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
                      video.duration,
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
                    video.category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: _getCategoryColor(video.category),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    video.title.toUpperCase(),
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
                    '$displayViews · $displayTime',
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
