import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';

class PlayerStats {
  final String id;
  final String name;
  final String position;
  final String nationality;
  final String shirtNumber;
  final String goals;
  final String assists;
  final String rating;
  final String imageUrl;

  PlayerStats({
    required this.id,
    required this.name,
    required this.position,
    required this.nationality,
    required this.shirtNumber,
    required this.goals,
    required this.assists,
    required this.rating,
    required this.imageUrl,
  });
}

class TopPlayersSection extends StatelessWidget {
  const TopPlayersSection({super.key});

  static final List<PlayerStats> _mockPlayers = [
    PlayerStats(
      id: '1',
      name: 'M. UNITED',
      position: 'FW',
      nationality: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      shirtNumber: '10',
      goals: '18',
      assists: '7',
      rating: '8.4',
      imageUrl: 'https://images.unsplash.com/photo-1543326727-cf6c39e8f84c?w=400&auto=format&fit=crop&q=60',
    ),
    PlayerStats(
      id: '2',
      name: 'B. FERNAND',
      position: 'MF',
      nationality: '🇵🇹',
      shirtNumber: '8',
      goals: '12',
      assists: '15',
      rating: '8.1',
      imageUrl: 'https://images.unsplash.com/photo-1543353071-873f17a7a088?w=400&auto=format&fit=crop&q=60',
    ),
    PlayerStats(
      id: '3',
      name: 'A. GARNACHO',
      position: 'FW',
      nationality: '🇦🇷',
      shirtNumber: '17',
      goals: '9',
      assists: '4',
      rating: '7.8',
      imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=400&auto=format&fit=crop&q=60',
    ),
    PlayerStats(
      id: '4',
      name: 'K. MAINOO',
      position: 'MF',
      nationality: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      shirtNumber: '37',
      goals: '4',
      assists: '3',
      rating: '7.9',
      imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=400&auto=format&fit=crop&q=60',
    ),
    PlayerStats(
      id: '5',
      name: 'D. DALOT',
      position: 'DF',
      nationality: '🇵🇹',
      shirtNumber: '20',
      goals: '2',
      assists: '6',
      rating: '7.6',
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&auto=format&fit=crop&q=60',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(
          title: 'TOP PLAYERS',
          actionLabel: 'SEE ALL',
        ),
        SizedBox(
          height: 200, // Card height (180) + padding
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _mockPlayers.length,
            itemBuilder: (context, index) {
              final player = _mockPlayers[index];
              return _buildPlayerCard(context, player);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(BuildContext context, PlayerStats player) {
    return GestureDetector(
      onTap: () => context.push('/squad/player/${player.id}'),
      child: Container(
        width: 150,
        height: 180,
        margin: const EdgeInsets.only(right: 12, top: 8, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [MifcColors.navy, MifcColors.navyDark],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Shirt Number Watermark
            Positioned(
              right: -10,
              bottom: 40,
              child: Opacity(
                opacity: 0.1,
                child: Text(
                  player.shirtNumber,
                  style: GoogleFonts.barlowCondensed(
                    color: MifcColors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Position + Nationality
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: MifcColors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          player.position,
                          style: GoogleFonts.barlowCondensed(
                            color: MifcColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        player.nationality,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Name
                  Text(
                    player.name,
                    style: GoogleFonts.barlowCondensed(
                      color: MifcColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn('GA', player.goals),
                      _buildStatColumn('AS', player.assists),
                      _buildStatColumn('RT', player.rating),
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

  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.barlow(
            color: MifcColors.white.withOpacity(0.5),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.barlowCondensed(
            color: MifcColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
