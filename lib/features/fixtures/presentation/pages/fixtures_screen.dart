import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import 'package:markfc/features/fixtures/data/repositories/fixtures_repository.dart';
import 'package:markfc/features/fixtures/domain/models/match_model.dart';

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
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MifcTopBar(
              opacity: _opacity,
              showBackButton: true,
              showCalendar: true,
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
        ],
      ),
    );
  }

  Widget _buildTabsHeader() {
    return Container(
      color: const Color(0xFF06080F),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: MifcColors.navyBlue,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            dividerColor: Colors.white.withValues(alpha: 0.05),
            labelStyle: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'UNITED'),
              Tab(text: 'ALL TEAMS'),
            ],
          ),
        ],
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => const SizedBox.shrink(),
        ),
        fixturesAsync.when(
          data: (fixtures) => _buildGroupedMatches(fixtures, 'UPCOMING FIXTURES'),
          loading: () => const Center(child: CircularProgressIndicator()),
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
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: MifcColors.navyBlue,
              letterSpacing: 2.0,
            ),
          ),
        ),
        ...grouped.entries.map((entry) => Column(
          children: [
            _MatchGroupHeader(title: entry.key),
            ...entry.value.map((m) => _MatchCard(match: m)),
          ],
        )),
      ],
    );
  }
}

class _MatchGroupHeader extends StatelessWidget {
  final String title;
  const _MatchGroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final MatchModel match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE d MMM | ').format(match.timestamp) + match.competition;
    
    return ScrollReveal(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: MifcCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
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
                        dateStr,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Match Info',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            match.homeTeam.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(width: 12),
                          _buildCrest(match.homeCode),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        match.status == MatchStatus.upcoming 
                          ? DateFormat('HH:mm').format(match.timestamp)
                          : '${match.homeScore} - ${match.awayScore}',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCrest(match.awayCode),
                          const SizedBox(width: 12),
                          Text(
                            match.awayTeam.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (match.status == MatchStatus.finished && match.scorers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    match.scorers.join(', '),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrest(String code) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
        border: Border.all(
          color: code.toUpperCase().contains('MIFC') ? MifcColors.crimson.withValues(alpha: 0.3) : Colors.white10,
        ),
      ),
      child: Center(
        child: Text(
          code.substring(0, code.length > 3 ? 3 : code.length),
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
