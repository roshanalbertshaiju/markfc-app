import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

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
      Share.share(widget.comment['text'] ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScrollReveal(
          type: AnimationType.fade,
          child: Screenshot(
            controller: _screenshotController,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  MifcCard(
                    elevation: 0,
                    color: widget.isPinned 
                        ? MifcColors.eliteBlue.withValues(alpha: 0.03) 
                        : (widget.isOfficial ? Colors.transparent : MifcColors.white.withValues(alpha: 0.02)),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: widget.isPinned 
                            ? Border.all(color: MifcColors.eliteBlue.withValues(alpha: 0.15))
                            : (widget.isOfficial 
                                ? Border.all(color: MifcColors.eliteBlue.withValues(alpha: 0.3), width: 1)
                                : Border.all(color: MifcColors.white.withValues(alpha: 0.05))),
                        gradient: widget.isOfficial 
                            ? LinearGradient(
                                colors: [MifcColors.black, MifcColors.charcoal.withValues(alpha: 0.8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.isPinned) _buildPinnedLabel(),
                          
                          Padding(
                            padding: const EdgeInsets.all(16),
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
                                const SizedBox(height: 12),
                                Text(
                                  widget.comment['text'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: MifcColors.white.withValues(alpha: 0.85),
                                    height: 1.6,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CommentActions(
                                  likes: _likes,
                                  isLiked: _isLiked,
                                  onLike: _handleLike,
                                  onReply: widget.onReply,
                                  onShare: _handleShare,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.isOfficial) _buildOfficialBadge(),
                ],
              ),
          ),
        ),
        if (widget.comment['replies'] != null)
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              children: List.generate(widget.comment['replies'].length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CommentCard(
                    comment: widget.comment['replies'][index],
                    isReply: true,
                    onReply: widget.onReply,
                  ),
                );
              }),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPinnedLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: MifcColors.eliteBlue.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Icon(Icons.push_pin_rounded, color: MifcColors.eliteBlue, size: 10),
          const SizedBox(width: 8),
          Text(
            'PINNED BY CLUB',
            style: GoogleFonts.outfit(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: MifcColors.eliteBlue,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialBadge() {
    return Positioned(
      top: -12,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: MifcColors.eliteBlue,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_rounded, color: MifcColors.black, size: 12),
            const SizedBox(width: 6),
            Text(
              'OFFICIAL RESPONSE',
              style: GoogleFonts.outfit(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: MifcColors.black,
                letterSpacing: 0.5,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user['name'] ?? '',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (isOfficial) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified_rounded, color: MifcColors.eliteBlue, size: 14),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    time.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: MifcColors.white.withValues(alpha: 0.3),
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    _buildUserBadge(),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (replyTo != null)
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
             decoration: BoxDecoration(
               color: MifcColors.white.withValues(alpha: 0.05),
               borderRadius: BorderRadius.circular(4),
             ),
             child: Text(
               'REPLYING TO @$replyTo'.toUpperCase(),
               style: GoogleFonts.outfit(
                 fontSize: 8,
                 fontWeight: FontWeight.w700,
                 color: MifcColors.white.withValues(alpha: 0.4),
               ),
             ),
           ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (isOfficial) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: MifcColors.eliteBlue, width: 1.5),
          color: MifcColors.black,
        ),
        alignment: Alignment.center,
        child: const Text('MIFC', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: MifcColors.white)),
      );
    }
    
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.primaries[user['id'] % Colors.primaries.length].withValues(alpha: 0.2),
        border: Border.all(color: Colors.primaries[user['id'] % Colors.primaries.length].withValues(alpha: 0.4)),
      ),
      alignment: Alignment.center,
      child: Text(
        user['initials'],
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.primaries[user['id'] % Colors.primaries.length],
        ),
      ),
    );
  }

  Widget _buildUserBadge() {
    Color color;
    switch (badge) {
      case 'GOLD MEMBER': color = MifcColors.eliteBlue; break;
      case 'SEASON TICKET': color = const Color(0xFF4CAF50); break;
      case 'TOP COMMENTER': color = const Color(0xFF9C27B0); break;
      default: color = MifcColors.eliteBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        badge!,
        style: GoogleFonts.outfit(
          fontSize: 7,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.5,
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
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: awards.map((award) => _buildAwardChip(award)).toList(),
      ),
    );
  }

  Widget _buildAwardChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF673AB7).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF673AB7).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome_rounded, size: 8, color: Color(0xFF9575CD)),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9575CD),
              letterSpacing: 0.2,
            ),
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
          icon: isLiked ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
          label: likes.toString(),
          color: isLiked ? MifcColors.eliteBlue : MifcColors.white.withValues(alpha: 0.4),
          onTap: onLike,
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          icon: Icons.thumb_down_outlined,
          label: '',
          color: MifcColors.white.withValues(alpha: 0.4),
          onTap: () {},
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: onReply,
          child: Row(
            children: [
              Icon(Icons.reply_rounded, size: 16, color: MifcColors.white.withValues(alpha: 0.4)),
              const SizedBox(width: 6),
              Text(
                'REPLY',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: MifcColors.white.withValues(alpha: 0.4),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onShare,
          icon: Icon(Icons.share_rounded, size: 16, color: MifcColors.white.withValues(alpha: 0.3)),
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
          Icon(icon, size: 16, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

