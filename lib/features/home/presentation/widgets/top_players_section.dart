import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

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
              return ScrollReveal(
                type: AnimationType.fade,
                delay: Duration(milliseconds: index * 100),
                child: _buildPlayerCard(context, player),
              );
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
        width: 140,
        margin: const EdgeInsets.only(right: 16, top: 8, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player Image with subtle border
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: MifcColors.white.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(player.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.shirtNumber,
                        style: GoogleFonts.outfit(
                          color: MifcColors.eliteBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              player.name,
              style: GoogleFonts.outfit(
                color: MifcColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Position & Rating
            Row(
              children: [
                Text(
                  player.position,
                  style: GoogleFonts.inter(
                    color: MifcColors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.star, color: MifcColors.eliteBlue, size: 10),
                const SizedBox(width: 4),
                Text(
                  player.rating,
                  style: GoogleFonts.outfit(
                    color: MifcColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
