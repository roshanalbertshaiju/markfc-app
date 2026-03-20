import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import '../../domain/models/match_model.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import 'package:markfc/features/fixtures/data/repositories/fixtures_repository.dart';

class FixturesScreen extends ConsumerStatefulWidget {
  const FixturesScreen({super.key});

  @override
  ConsumerState<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends ConsumerState<FixturesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _activeTab) {
        setState(() {
          _activeTab = _tabController.index;
        });
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    double newOpacity = 0.0;
    
    if (offset <= 50) {
      newOpacity = 0.0;
    } else if (offset >= 120) {
      newOpacity = 1.0;
    } else {
      newOpacity = (offset - 50) / 70.0;
    }

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06080F),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fixturesStreamProvider);
              ref.invalidate(resultsStreamProvider);
              // Wait a bit to show the animation
              await Future.delayed(const Duration(milliseconds: 500));
            },
            color: MifcColors.crimson,
            backgroundColor: const Color(0xFF0F172A),
            displacement: 100, // Displace below the transparent top bar
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildHero(),
                _buildTabsHeader(),
                _activeTab == 0 
                  ? const _FixturesList()
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Text(
                          'All Teams Fixtures Coming Soon', 
                          style: TextStyle(color: Colors.white70)
                        ),
                      ),
                    ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MifcTopBar(
              opacity: _opacity,
              showBackButton: true,
              showCalendar: true,
              hideLogo: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 340,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1522778119026-d647f0596c20?q=80&w=2000',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  const Color(0xFF06080F),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: MifcColors.crimson,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SEASON 2025/26',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'MATCHES & FIXTURES',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Follow the journey of the United squad',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'OFFICIAL GLOBAL PARTNER',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Image.asset(
                  'assets/images/mark_international_logo.png',
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MifcColors.crimson.withValues(alpha: 0.15),
                border: Border.all(
                  color: MifcColors.crimson.withValues(alpha: 0.3),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
              labelStyle: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
              tabs: const [
                Tab(text: 'UNITED'),
                Tab(text: 'ALL TEAMS'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FixturesList extends ConsumerWidget {
  const _FixturesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fixturesAsync = ref.watch(fixturesStreamProvider);
    final resultsAsync = ref.watch(resultsStreamProvider);

    return Column(
      children: [
        resultsAsync.when(
          data: (results) => _buildGroupedMatches(results, 'COMPLETED MATCHES'),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: MifcColors.crimson),
            ),
          ),
          error: (err, stack) => const SizedBox.shrink(),
        ),
        fixturesAsync.when(
          data: (fixtures) => _buildGroupedMatches(fixtures, 'UPCOMING FIXTURES'),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: MifcColors.crimson),
            ),
          ),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildGroupedMatches(List<MatchModel> matches, String title) {
    if (matches.isEmpty) return const SizedBox.shrink();

    // Group by Month
    final Map<String, List<MatchModel>> grouped = {};
    for (var m in matches) {
      final month = DateFormat('MMMM yyyy').format(m.timestamp).toUpperCase();
      grouped.putIfAbsent(month, () => []).add(m);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: MifcColors.crimson,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
        ...grouped.entries.map((entry) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text(
                entry.key,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.3),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            ...entry.value.map((m) => _MatchCard(match: m)),
          ],
        )),
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  final MatchModel match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    // Unified name handling
    final bool isHomeMifc = match.homeCode.toUpperCase().contains('MIFC') || match.homeTeam.toUpperCase().contains('MARK');
    final bool isAwayMifc = match.awayCode.toUpperCase().contains('MIFC') || match.awayTeam.toUpperCase().contains('MARK');
    
    final String homeName = isHomeMifc ? "MARK INT FC" : match.homeTeam.toUpperCase();
    final String awayName = isAwayMifc ? "MARK INT FC" : match.awayTeam.toUpperCase();

    final dateStr = DateFormat('EEE d MMM').format(match.timestamp);
    final timeStr = DateFormat('HH:mm').format(match.timestamp);

    return ScrollReveal(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Match Header Info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "UNITED MATCH · ${match.competition.toUpperCase()}",
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: MifcColors.crimson,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Text(
                          dateStr.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Main Match Info
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Home Team
                        Expanded(
                          child: Column(
                            children: [
                              _buildCrest(match.homeCode, isHomeMifc, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                homeName,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Score / Time / Status
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              if (match.status == MatchStatus.upcoming) ...[
                                Text(
                                  timeStr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: MifcColors.navyBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: MifcColors.navyBlue.withValues(alpha: 0.2)),
                                  ),
                                  child: Text(
                                    'UPCOMING',
                                    style: GoogleFonts.outfit(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: MifcColors.navyBlue,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  '${match.homeScore} - ${match.awayScore}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                                if (match.status == MatchStatus.live) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: MifcColors.crimson,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'LIVE',
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: MifcColors.crimson,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        
                        // Away Team
                        Expanded(
                          child: Column(
                            children: [
                              _buildCrest(match.awayCode, isAwayMifc, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                awayName,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Footer Info (Venue & Scorers)
                  if (match.scorers.isNotEmpty || match.venue.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.01),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.03),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          if (match.scorers.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                match.scorers.join(' • '),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (match.venue.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on_outlined, size: 10, color: Colors.white24),
                                const SizedBox(width: 4),
                                Text(
                                  match.venue.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white24,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCrest(String code, bool isMifc, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
        border: Border.all(
          color: isMifc ? MifcColors.crimson.withValues(alpha: 0.3) : Colors.white10,
          width: 1.5,
        ),
        boxShadow: isMifc ? [
          BoxShadow(
            color: MifcColors.crimson.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ] : null,
      ),
      child: ClipOval(
        child: isMifc 
          ? Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                'assets/images/mifc_logo.png',
                fit: BoxFit.contain,
              ),
            )
          : Center(
              child: Text(
                code.length > 3 ? code.substring(0, 3) : code,
                style: GoogleFonts.outfit(
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
      ),
    );
  }
}
