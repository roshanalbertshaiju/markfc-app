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
      name: 'MARCUS RASHFORD',
      position: 'FW',
      nationality: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      shirtNumber: '10',
      goals: '18',
      assists: '7',
      rating: '8.4',
      imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=800&q=80',
    ),
    PlayerStats(
      id: '2',
      name: 'BRUNO FERNANDES',
      position: 'MF',
      nationality: '🇵🇹',
      shirtNumber: '8',
      goals: '12',
      assists: '15',
      rating: '8.1',
      imageUrl: 'https://images.unsplash.com/photo-1543353071-873f17a7a088?w=800&q=80',
    ),
    PlayerStats(
      id: '3',
      name: 'ALEJANDRO GARNACHO',
      position: 'FW',
      nationality: '🇦🇷',
      shirtNumber: '17',
      goals: '9',
      assists: '4',
      rating: '7.8',
      imageUrl: 'https://images.unsplash.com/photo-1551244072-5d12893278ab?w=800&q=80',
    ),
    PlayerStats(
      id: '4',
      name: 'KOBBIE MAINOO',
      position: 'MF',
      nationality: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      shirtNumber: '37',
      goals: '4',
      assists: '3',
      rating: '7.9',
      imageUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?w=800&q=80',
    ),
    PlayerStats(
      id: '5',
      name: 'DIOGO DALOT',
      position: 'DF',
      nationality: '🇵🇹',
      shirtNumber: '20',
      goals: '2',
      assists: '6',
      rating: '7.6',
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80',
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
          height: 240, // Increased height for better card proportions
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
    return Container(
      width: 160, // Wider card
      margin: const EdgeInsets.only(right: 16, top: 4, bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/squad/player/${player.id}'),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Main Image Container with gradient
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: MifcColors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(player.imageUrl),
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.2), // Adjust crop focus
                      ),
                    ),
                  ),
                  // Darken & Info Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  // Shirt Number Floating Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: MifcColors.navyBlue,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        player.shirtNumber,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Bottom Info Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            player.name,
                            style: GoogleFonts.outfit(
                              color: MifcColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: MifcColors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  player.position,
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.stars_rounded,
                                color: MifcColors.prestigeGold,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                player.rating,
                                style: GoogleFonts.outfit(
                                  color: MifcColors.prestigeGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
