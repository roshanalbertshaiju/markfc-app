import 'package:flutter/material.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/latest_news_section.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import '../widgets/fixture_countdown_section.dart';
import '../widgets/player_of_the_month_section.dart';
import '../widgets/top_players_section.dart';
import '../widgets/league_table_section.dart';
import '../widgets/mifc_tv_section.dart';
import '../widgets/fan_of_the_month_section.dart';
import '../widgets/sponsor_strip_section.dart';
import 'package:markfc/features/news/data/repositories/news_repository.dart';
import 'package:markfc/features/home/data/repositories/hero_repository.dart';
import 'package:markfc/features/fixtures/data/repositories/fixtures_repository.dart';
import 'package:markfc/features/home/data/repositories/league_repository.dart';
import 'package:markfc/features/squad/data/repositories/squad_repository.dart';
import 'package:markfc/features/profile/data/repositories/profile_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    double newOpacity = 0.0;
    
    if (offset <= 50) {
      newOpacity = 0.0;
    } else if (offset >= 200) {
      newOpacity = 1.0;
    } else {
      newOpacity = (offset - 50) / 150.0;
    }

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              // Invalidate all main home page providers
              ref.invalidate(heroSlidesStreamProvider);
              ref.invalidate(latestNewsProvider);
              ref.invalidate(liveMatchStreamProvider);
              ref.invalidate(resultsStreamProvider);
              ref.invalidate(leagueTableStreamProvider);
              ref.invalidate(topPlayersStreamProvider);
              
              // Wait a bit to show the animation
              await Future.delayed(const Duration(milliseconds: 800));
            },
            color: MifcColors.crimson,
            backgroundColor: const Color(0xFF0F172A),
            displacement: 100,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(), // Ensure it's scrollable for pull-to-refresh
              children: [
                _buildGreeting(),
                const HeroCarousel(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 100),
                  child: LatestNewsSection(),
                ),
                _buildDivider(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 200),
                  child: FixtureCountdownSection(),
                ),
                _buildDivider(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 300),
                  child: PlayerOfTheMonthSection(),
                ),
                _buildDivider(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 400),
                  child: TopPlayersSection(),
                ),
                _buildDivider(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 500),
                  child: LeagueTableSection(),
                ),
                _buildDivider(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 600),
                  child: MifcTvSection(),
                ),
                _buildDivider(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 700),
                  child: FanOfTheMonthSection(),
                ),
                _buildDivider(),
                const ScrollReveal(
                  delay: Duration(milliseconds: 800),
                  child: SponsorStripSection(),
                ),
                const SizedBox(height: 100), 
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MifcTopBar(opacity: _opacity),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: MifcColors.crimson,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.chat_bubble_outline, color: MifcColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildGreeting() {
    final userAsync = ref.watch(currentUserProvider);
    final hour = DateTime.now().hour;
    String greeting = "Welcome back";
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: userAsync.when(
        data: (user) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting,',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              user?.name ?? 'Mark FC Fan',
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        loading: () => const SizedBox(height: 50),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 48,
      thickness: 1,
      color: MifcColors.white.withValues(alpha: 0.03),
      indent: 24,
      endIndent: 24,
    );
  }
}
