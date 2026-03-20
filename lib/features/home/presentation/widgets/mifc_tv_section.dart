import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/features/news/domain/models/video_content.dart';
import 'package:markfc/features/news/data/repositories/video_repository.dart';

class MifcTvSection extends ConsumerWidget {
  const MifcTvSection({super.key});

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M VIEWS';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K VIEWS';
    } else {
      return '$views VIEWS';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM yyyy').format(timestamp).toUpperCase();
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} DAYS AGO';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} HOURS AGO';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} MINUTES AGO';
    } else {
      return 'JUST NOW';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(allVideosProvider);

    return Column(
      children: [
        const SectionHeader(title: 'MIFC TV', actionLabel: 'WATCH ALL'),
        SizedBox(
          height: 280, // Slightly increased to fit content
          child: videosAsync.when(
            data: (videos) {
              if (videos.isEmpty) {
                return const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white30)));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: videos.length > 5 ? 5 : videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return VideoCard(
                    video: video,
                    displayViews: _formatViews(video.views),
                    displayTime: _formatTime(video.timestamp),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white30))),
          ),
        ),
      ],
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoContent video;
  final String displayViews;
  final String displayTime;

  const VideoCard({
    super.key,
    required this.video,
    required this.displayViews,
    required this.displayTime,
  });

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'HIGHLIGHTS':
        return MifcColors.navyBlue;
      case 'EXCLUSIVE':
      case 'INTERVIEW':
        return MifcColors.crimson;
      case 'INSIDE':
      case 'TRAINING':
        return MifcColors.prestigeGold;
      default:
        return MifcColors.white.withValues(alpha: 0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 154,
            decoration: BoxDecoration(
              color: MifcColors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: MifcColors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Actual video thumbnail using CachedNetworkImage
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: video.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              MifcColors.white.withValues(alpha: 0.02),
                              MifcColors.white.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: MifcColors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.category,
                      style: GoogleFonts.outfit(
                        color: _getCategoryColor(video.category),
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: MifcColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: MifcColors.black, size: 24),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Text(
                    video.duration,
                    style: GoogleFonts.outfit(
                      color: MifcColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            video.title.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: MifcColors.white,
              letterSpacing: 0.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$displayViews · $displayTime',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: MifcColors.white.withValues(alpha: 0.3),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
