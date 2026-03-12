import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/mifc_colors.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> comment;
  final bool isPinned;
  final bool isOfficial;
  final bool isReply;
  final VoidCallback? onReply;

  const CommentCard({
    super.key,
    required this.comment,
    this.isPinned = false,
    this.isOfficial = false,
    this.isReply = false,
    this.onReply,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isLiked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.comment['likes'] ?? 0;
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  Future<void> _handleShare() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      // In a real app, you'd save it to a temp file first
      // Share.shareXFiles([XFile.fromData(image, mimeType: 'image/png')]);
      Share.share(widget.comment['text'] ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
          controller: _screenshotController,
          child: Container(
            margin: EdgeInsets.only(
              left: widget.isReply ? 36 : 16,
              right: 16,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: widget.isPinned 
                  ? MifcColors.gold.withOpacity(0.05) 
                  : (widget.isOfficial ? Colors.transparent : MifcColors.card),
              borderRadius: BorderRadius.circular(14),
              border: widget.isPinned 
                  ? Border.all(color: MifcColors.gold.withOpacity(0.2))
                  : (widget.isOfficial 
                      ? Border.all(color: MifcColors.gold, width: 1.5)
                      : null),
              gradient: widget.isOfficial 
                  ? const LinearGradient(
                      colors: [MifcColors.navyDark, MifcColors.navy],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              boxShadow: widget.isOfficial 
                  ? [BoxShadow(color: MifcColors.gold.withOpacity(0.1), blurRadius: 10)]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isPinned) _buildPinnedLabel(),
                if (widget.isOfficial) _buildOfficialBadge(),
                
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentHeader(
                        user: widget.comment['user'],
                        time: widget.comment['time'],
                        badge: widget.comment['userBadge'],
                        isOfficial: widget.isOfficial,
                        replyTo: widget.comment['replyTo'],
                      ),
                      if (widget.comment['awards'] != null) 
                        AwardBadgesRow(awards: widget.comment['awards']),
                      const SizedBox(height: 8),
                      Text(
                        widget.comment['text'] ?? '',
                        style: GoogleFonts.barlow(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CommentActions(
                        likes: _likes,
                        isLiked: _isLiked,
                        onLike: _handleLike,
                        onReply: widget.onReply,
                        onShare: _handleShare,
                      ),
                      if (!widget.isReply) 
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              '← swipe to reply',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white24,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.comment['replies'] != null)
          ...List.generate(widget.comment['replies'].length, (index) {
            return CommentCard(
              comment: widget.comment['replies'][index],
              isReply: true,
              onReply: widget.onReply,
            );
          }),
      ],
    );
  }

  Widget _buildPinnedLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.push_pin, color: MifcColors.gold, size: 10),
          const SizedBox(width: 6),
          Text(
            'PINNED BY MIFC',
            style: GoogleFonts.barlowCondensed(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: MifcColors.gold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialBadge() {
    return Positioned(
      top: -10,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: MifcColors.gold,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, color: Colors.black, size: 12),
            const SizedBox(width: 4),
            Text(
              'MIFC OFFICIAL REPLY',
              style: GoogleFonts.barlowCondensed(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentHeader extends StatelessWidget {
  final Map<String, dynamic> user;
  final String time;
  final String? badge;
  final bool isOfficial;
  final String? replyTo;

  const CommentHeader({
    super.key,
    required this.user,
    required this.time,
    this.badge,
    this.isOfficial = false,
    this.replyTo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user['name'] ?? '',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    _buildUserBadge(),
                  ],
                ],
              ),
              if (replyTo != null)
                Text(
                  'Replying to @$replyTo',
                  style: GoogleFonts.barlow(
                    fontSize: 10,
                    color: MifcColors.mutedOpacity,
                  ),
                )
              else
                Text(
                  isOfficial ? 'Official · $time' : time,
                  style: GoogleFonts.barlow(
                    fontSize: 9,
                    color: MifcColors.mutedOpacity,
                  ),
                ),
            ],
          ),
        ),
        if (isOfficial) 
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.verified, color: MifcColors.gold, size: 14),
          ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (isOfficial) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: MifcColors.gold, width: 1.5),
          gradient: const LinearGradient(
            colors: [MifcColors.navy, MifcColors.navyDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        alignment: Alignment.center,
        child: const Text('MIFC', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
      );
    }
    
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.primaries[user['id'] % Colors.primaries.length],
      child: Text(
        user['initials'],
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildUserBadge() {
    Color color;
    switch (badge) {
      case 'GOLD MEMBER': color = MifcColors.gold; break;
      case 'SEASON TICKET': color = Colors.greenAccent; break;
      case 'TOP COMMENTER': color = Colors.purpleAccent; break;
      default: color = MifcColors.gold;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        badge!,
        style: GoogleFonts.barlowCondensed(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

class AwardBadgesRow extends StatelessWidget {
  final List<String> awards;
  const AwardBadgesRow({super.key, required this.awards});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 4,
        children: awards.map((award) => _buildAwardChip(award)).toList(),
      ),
    );
  }

  Widget _buildAwardChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, size: 8, color: Colors.purpleAccent),
          const SizedBox(width: 2),
          Text(
            text,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
          ),
        ],
      ),
    );
  }
}

class CommentActions extends StatelessWidget {
  final int likes;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback? onReply;
  final VoidCallback onShare;

  const CommentActions({
    super.key,
    required this.likes,
    required this.isLiked,
    required this.onLike,
    this.onReply,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
          label: likes.toString(),
          color: isLiked ? MifcColors.gold : Colors.white54,
          onTap: onLike,
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.thumb_down_outlined,
          label: '',
          color: Colors.white54,
          onTap: () {},
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onReply,
          child: Row(
            children: [
              const Icon(Icons.reply, size: 14, color: Colors.white54),
              const SizedBox(width: 4),
              Text(
                'Reply',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onShare,
          icon: const Icon(Icons.share_outlined, size: 14, color: Colors.white54),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }
}
