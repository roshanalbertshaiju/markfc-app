import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import '../../domain/models/player.dart';
import '../widgets/player_card.dart';

class SquadScreen extends StatefulWidget {
  const SquadScreen({super.key});

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Player> _mockPlayers = [
    // Goalkeepers
    const Player(
      id: '1',
      name: 'Altay Bayindir',
      number: '1',
      position: PlayerPosition.goalkeeper,
      category: TeamCategory.men,
      imageUrl: 'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?q=80&w=200&h=240&auto=format&fit=crop',
    ),
    const Player(
      id: '2',
      name: 'Andre Onana',
      number: '24',
      position: PlayerPosition.goalkeeper,
      category: TeamCategory.men,
      imageUrl: 'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?q=80&w=200&h=240&auto=format&fit=crop',
      isOnLoan: true,
    ),
    // Defenders
    const Player(
      id: '3',
      name: 'Diogo Dalot',
      number: '2',
      position: PlayerPosition.defender,
      category: TeamCategory.men,
      imageUrl: 'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?q=80&w=200&h=240&auto=format&fit=crop',
    ),
    const Player(
      id: '4',
      name: 'Noussair Mazraoui',
      number: '3',
      position: PlayerPosition.defender,
      category: TeamCategory.men,
      imageUrl: 'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?q=80&w=200&h=240&auto=format&fit=crop',
    ),
    const Player(
      id: '5',
      name: 'Harry Maguire',
      number: '5',
      position: PlayerPosition.defender,
      category: TeamCategory.men,
      imageUrl: 'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?q=80&w=200&h=240&auto=format&fit=crop',
    ),
    // Midfielders
    const Player(
      id: '6',
      name: 'Bruno Fernandes',
      number: '8',
      position: PlayerPosition.midfielder,
      category: TeamCategory.men,
      imageUrl: 'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?q=80&w=200&h=240&auto=format&fit=crop',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      body: Column(
        children: [
          // Subheader Tabs
          Container(
            color: MifcColors.crimson,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: MifcColors.white,
              indicatorWeight: 3,
              labelColor: MifcColors.white,
              unselectedLabelColor: MifcColors.white.withValues(alpha: 0.6),
              labelStyle: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
              unselectedLabelStyle: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
              tabs: const [
                Tab(text: 'MEN'),
                Tab(text: 'WOMEN'),
                Tab(text: 'UNDER-21S'),
                Tab(text: 'UNDER-18S'),
              ],
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSquadList(TeamCategory.men),
                const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white))),
                const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white))),
                const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquadList(TeamCategory category) {
    final players = _mockPlayers.where((p) => p.category == category).toList();
    
    // Group by position
    final goalkeepers = players.where((p) => p.position == PlayerPosition.goalkeeper).toList();
    final defenders = players.where((p) => p.position == PlayerPosition.defender).toList();
    final midfielders = players.where((p) => p.position == PlayerPosition.midfielder).toList();
    final forwards = players.where((p) => p.position == PlayerPosition.forward).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        if (goalkeepers.isNotEmpty) ...[
          _buildCategoryHeader('GOALKEEPERS'),
          _buildPlayerGrid(goalkeepers),
        ],
        if (defenders.isNotEmpty) ...[
          _buildCategoryHeader('DEFENDERS'),
          _buildPlayerGrid(defenders),
        ],
        if (midfielders.isNotEmpty) ...[
          _buildCategoryHeader('MIDFIELDERS'),
          _buildPlayerGrid(midfielders),
        ],
        if (forwards.isNotEmpty) ...[
          _buildCategoryHeader('FORWARDS'),
          _buildPlayerGrid(forwards),
        ],
      ],
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: MifcColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: MifcColors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerGrid(List<Player> players) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        return PlayerCard(player: players[index]);
      },
    );
  }
}
