import 'package:flutter/material.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/latest_news_section.dart';
import '../widgets/match_centre_section.dart';
import '../widgets/motm_poll_section.dart';
import '../widgets/fixture_countdown_section.dart';
import '../widgets/player_of_the_month_section.dart';
import '../widgets/top_players_section.dart';
import '../widgets/league_table_section.dart';
import '../widgets/mifc_tv_section.dart';
import '../widgets/fan_of_the_month_section.dart';
import '../widgets/sponsor_strip_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: [
              const HeroCarousel(),
              const LatestNewsSection(),
              _buildDivider(),
              const MatchCentreSection(),
              _buildDivider(),
              const MotmPollSection(),
              _buildDivider(),
              const FixtureCountdownSection(), 
              _buildDivider(),
              const PlayerOfTheMonthSection(),
              _buildDivider(),
              const TopPlayersSection(), 
              _buildDivider(),
              const LeagueTableSection(),
              _buildDivider(),
              const MifcTvSection(),
              _buildDivider(),
              const FanOfTheMonthSection(),
              _buildDivider(),
              const SponsorStripSection(),
              const SizedBox(height: 100), 
            ],
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
