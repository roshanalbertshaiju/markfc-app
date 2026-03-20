import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import 'package:markfc/features/squad/data/repositories/squad_repository.dart';
import 'package:markfc/features/squad/domain/models/player.dart';
import 'package:markfc/features/squad/presentation/widgets/player_card.dart';

class SquadScreen extends ConsumerStatefulWidget {
  const SquadScreen({super.key});

  @override
  ConsumerState<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends ConsumerState<SquadScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
                _SquadList(category: TeamCategory.men),
                _SquadList(category: TeamCategory.women),
                _SquadList(category: TeamCategory.u21),
                _SquadList(category: TeamCategory.u18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SquadList extends ConsumerWidget {
  final TeamCategory category;
  
  const _SquadList({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersStreamProvider(category));

    return playersAsync.when(
      data: (players) {
        if (players.isEmpty) {
          return const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white70)));
        }

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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error loading squad', style: TextStyle(color: Colors.white70))),
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
