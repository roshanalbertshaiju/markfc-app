import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/mifc_colors.dart';
import 'live_readers_bar.dart';
import 'reactions_bar.dart';
import 'inline_poll_card.dart';
import 'discussion_header.dart';
import 'comment_card.dart';
import 'discussion_input_bar.dart';

class DiscussionSection extends StatefulWidget {
  const DiscussionSection({super.key});

  @override
  State<DiscussionSection> createState() => _DiscussionSectionState();
}

class _DiscussionSectionState extends State<DiscussionSection> {
  String? _replyTarget;

  final List<Map<String, dynamic>> _mockComments = [
    {
      'id': 1,
      'isPinned': true,
      'user': {'name': 'Mark International FC', 'initials': 'MIFC', 'id': 0},
      'time': '1 hour ago',
      'text': '🏆 What a performance from the lads tonight! Share your reactions below and vote for your Man of the Match. Next up: Manchester City on Saturday — see you at Old Trafford! 💙',
      'likes': 842,
    },
    {
      'id': 2,
      'isOfficial': true,
      'user': {'name': 'Mark International FC', 'initials': 'MIFC', 'id': 0},
      'time': '30 mins ago',
      'replyTo': 'Adebayo James',
      'text': 'Thanks Adebayo — your support means everything to this club! 💙 Make sure to grab your City tickets before they sell out!',
      'likes': 412,
    },
    {
      'id': 3,
      'user': {'name': 'Adebayo James', 'initials': 'AJ', 'id': 1},
      'time': '2 hours ago',
      'userBadge': 'GOLD MEMBER',
      'awards': ['Most Liked This Week', 'First to Comment'],
      'text': "Salah was absolutely unplayable today. Two goals and could've had four. This is why you never let the man leave. MIFC till I die! 🔥🔥",
      'likes': 124,
      'replies': [
        {
          'id': 4,
          'user': {'name': 'Mohammed K.', 'initials': 'MK', 'id': 2},
          'time': '1 hour ago',
          'replyTo': 'Adebayo James',
          'text': 'Agreed! That first touch for the second goal was genuinely world class 🙌',
          'likes': 34,
        },
        {
          'id': 5,
          'user': {'name': 'Sarah R.', 'initials': 'SR', 'id': 3},
          'time': '45 mins ago',
          'replyTo': 'Adebayo James',
          'text': "He's just built different. No one can live with him on his day 💙",
          'likes': 18,
        },
      ],
    },
    {
      'id': 6,
      'user': {'name': 'Peter O.', 'initials': 'PO', 'id': 4},
      'time': '4 hours ago',
      'userBadge': 'TOP COMMENTER',
      'text': "Ekitike's goal was the one for me. That run in behind, the composure — he's going to be special. 🎯",
      'likes': 61,
    }
  ];

  void _handleReply(String username) {
    setState(() => _replyTarget = username);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LiveReadersBar(),
        const ReactionsBar(),
        const InlinePollCard(),
        const DiscussionHeader(),
        
        // Comments List
        ..._mockComments.map((comment) => CommentCard(
          comment: comment,
          isPinned: comment['isPinned'] ?? false,
          isOfficial: comment['isOfficial'] ?? false,
          onReply: () => _handleReply(comment['user']['name']),
        )),

        _buildLoadMoreButton(),
        
        const SizedBox(height: 20),
        _buildRelatedArticlesHeader(),
        
        DiscussionInputBar(
          replyTarget: _replyTarget,
          onCancelReply: () => setState(() => _replyTarget = null),
          onSend: (text) {
            // In a real app, send to Firestore
            setState(() => _replyTarget = null);
          },
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.expand_more, color: MifcColors.red, size: 18),
            const SizedBox(width: 4),
            Text(
              'Load 45 more comments',
              style: GoogleFonts.barlowCondensed(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: MifcColors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedArticlesHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'RELATED ARTICLES',
          style: GoogleFonts.barlowCondensed(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
