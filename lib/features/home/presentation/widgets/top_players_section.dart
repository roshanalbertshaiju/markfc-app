import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import 'package:markfc/features/squad/data/repositories/squad_repository.dart';
import 'package:markfc/features/squad/domain/models/player.dart';

class TopPlayersSection extends ConsumerWidget {
  const TopPlayersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPlayersAsync = ref.watch(topPlayersStreamProvider);

    return Column(
      children: [
        const SectionHeader(
          title: 'TOP PLAYERS',
          actionLabel: 'SEE ALL',
        ),
        SizedBox(
          height: 240,
          child: topPlayersAsync.when(
            data: (players) {
              if (players.isEmpty) return const SizedBox.shrink();
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return ScrollReveal(
                    type: AnimationType.fade,
                    delay: Duration(milliseconds: index * 100),
                    child: _buildPlayerCard(context, player),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(BuildContext context, Player player) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, top: 4, bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/squad/player/${player.id}'),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
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
                        alignment: const Alignment(0, -0.2),
                      ),
                    ),
                  ),
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
                        player.number,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
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
                            player.name.toUpperCase(),
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
                                  _getPositionAbbr(player.position),
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
                                player.rating.toStringAsFixed(1),
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

  String _getPositionAbbr(PlayerPosition pos) {
    switch (pos) {
      case PlayerPosition.goalkeeper: return 'GK';
      case PlayerPosition.defender: return 'DF';
      case PlayerPosition.midfielder: return 'MF';
      case PlayerPosition.forward: return 'FW';
    }
  }
}
