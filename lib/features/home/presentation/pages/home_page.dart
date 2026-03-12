import 'package:flutter/material.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/latest_news_section.dart';
import '../widgets/match_centre_section.dart';
import '../widgets/motm_poll_section.dart';
import '../widgets/player_of_the_month_section.dart';
import '../widgets/top_players_section.dart';
import '../widgets/league_table_section.dart';
import '../widgets/mifc_tv_section.dart';
import '../widgets/fan_of_the_month_section.dart';
import '../widgets/sponsor_strip_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MifcTopBar(),
      body: ListView(
        children: [
          const HeroCarousel(),
          _buildDivider(),
          const LatestNewsSection(),
          _buildDivider(),
          const MatchCentreSection(),
          _buildDivider(),
          const MotmPollSection(),
          _buildDivider(),
          const FixtureCountdownSection(), // Moved up
          _buildDivider(),
          const PlayerOfTheMonthSection(),
          _buildDivider(),
          const TopPlayersSection(), // Added
          _buildDivider(),
          const LeagueTableSection(),
          _buildDivider(),
          const MifcTvSection(),
          _buildDivider(),
          const FanOfTheMonthSection(),
          _buildDivider(),
          const SponsorStripSection(),
          const SizedBox(height: 100), // Space for FAB and Nav Bar
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: MifcColors.red,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 8,
      color: const Color(0xFFE4E7F5),
    );
  }
}
