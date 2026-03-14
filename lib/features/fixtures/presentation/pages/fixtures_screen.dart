import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class FixturesScreen extends StatefulWidget {
  const FixturesScreen({super.key});

  @override
  State<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends State<FixturesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06080F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        elevation: 0,
        title: Text(
          'MATCHES',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/calendar_icon.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Calendar',
                      style: GoogleFonts.outfit(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: MifcColors.navyBlue,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMatchesList(),
          const Center(child: Text('All Teams Fixtures', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildMatchesList() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        _MatchGroupHeader(title: 'SEPTEMBER 2025'),
        _MatchCard(
          date: 'Sat 13 Sep | English Premier League',
          homeTeam: 'Grimsby',
          awayTeam: 'Mark Intl',
          homeScore: '2',
          awayScore: '2',
          isReviewAvailable: true,
        ),
        _MatchCard(
          date: 'Sat 20 Sep | English Premier League',
          homeTeam: 'Mark Intl',
          awayTeam: 'Burnley',
          homeScore: '3',
          awayScore: '2',
          isReviewAvailable: true,
        ),
        _MatchGroupHeader(title: 'OCTOBER 2025'),
        _MatchCard(
          date: 'Sun 04 Oct | English Premier League',
          homeTeam: 'Man City',
          awayTeam: 'Mark Intl',
          homeScore: '3',
          awayScore: '0',
          isReviewAvailable: true,
        ),
        _MatchCard(
          date: 'Sat 10 Oct | English Premier League',
          homeTeam: 'Mark Intl',
          awayTeam: 'Chelsea',
          homeScore: '2',
          awayScore: '1',
          isReviewAvailable: true,
        ),
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
  final String date;
  final String homeTeam;
  final String awayTeam;
  final String homeScore;
  final String awayScore;
  final bool isReviewAvailable;

  const _MatchCard({
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    this.isReviewAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: MifcCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Header with Date & Table button
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
                        date,
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
                        'Table',
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
              // Main Match Info
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            homeTeam,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(width: 12),
                          _buildCrest(homeTeam),
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
                        '$homeScore - $awayScore',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCrest(awayTeam),
                          const SizedBox(width: 12),
                          Text(
                            awayTeam,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
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
              // Review Link
              if (isReviewAvailable)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MATCH REVIEW',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.trending_flat_rounded,
                        color: MifcColors.crimson,
                        size: 18,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrest(String team) {
    // Mock crests using icons for now
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.shield, color: Colors.white24, size: 18),
      ),
    );
  }
}
