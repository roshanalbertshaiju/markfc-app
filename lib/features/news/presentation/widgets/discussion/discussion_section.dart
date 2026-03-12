import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
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
      'user': {'name': 'MARK INTERNATIONAL FC', 'initials': 'MIFC', 'id': 0},
      'time': '1 HOUR AGO',
      'text': '🏆 WHAT A PERFORMANCE FROM THE LADS TONIGHT! SHARE YOUR REACTIONS BELOW AND VOTE FOR YOUR MAN OF THE MATCH. NEXT UP: MANCHESTER CITY ON SATURDAY — SEE YOU AT OLD TRAFFORD! ⚽',
      'likes': 842,
    },
    {
      'id': 2,
      'isOfficial': true,
      'user': {'name': 'MARK INTERNATIONAL FC', 'initials': 'MIFC', 'id': 0},
      'time': '30 MINS AGO',
      'replyTo': 'ADEBAYO JAMES',
      'text': 'THANKS ADEBAYO — YOUR SUPPORT MEANS EVERYTHING TO THIS CLUB! 🔴 MAKE SURE TO GRAB YOUR CITY TICKETS BEFORE THEY SELL OUT!',
      'likes': 412,
    },
    {
      'id': 3,
      'user': {'name': 'ADEBAYO JAMES', 'initials': 'AJ', 'id': 1},
      'time': '2 HOURS AGO',
      'userBadge': 'GOLD MEMBER',
      'awards': ['MOST LIKED THIS WEEK', 'FIRST TO COMMENT'],
      'text': "SALAH WAS ABSOLUTELY UNPLAYABLE TODAY. TWO GOALS AND COULD'VE HAD FOUR. THIS IS WHY YOU NEVER LET THE MAN LEAVE. MIFC TILL I DIE! 🔥🔥",
      'likes': 124,
      'replies': [
        {
          'id': 4,
          'user': {'name': 'MOHAMMED K.', 'initials': 'MK', 'id': 2},
          'time': '1 HOUR AGO',
          'replyTo': 'ADEBAYO JAMES',
          'text': 'AGREED! THAT FIRST TOUCH FOR THE SECOND GOAL WAS GENUINELY WORLD CLASS 🙌',
          'likes': 34,
        },
        {
          'id': 5,
          'user': {'name': 'SARAH R.', 'initials': 'SR', 'id': 3},
          'time': '45 MINS AGO',
          'replyTo': 'ADEBAYO JAMES',
          'text': "HE'S JUST BUILT DIFFERENT. NO ONE CAN LIVE WITH HIM ON HIS DAY 🔴",
          'likes': 18,
        },
      ],
    },
    {
      'id': 6,
      'user': {'name': 'PETER O.', 'initials': 'PO', 'id': 4},
      'time': '4 HOURS AGO',
      'userBadge': 'TOP COMMENTER',
      'text': "EKITIKE'S GOAL WAS THE ONE FOR ME. THAT RUN IN BEHIND, THE COMPOSURE — HE'S GOING TO BE SPECIAL. 🎯",
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
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.keyboard_arrow_down_rounded, color: MifcColors.eliteBlue, size: 18),
            const SizedBox(width: 8),
            Text(
              'LOAD 45 MORE COMMENTS',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: MifcColors.eliteBlue,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedArticlesHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'RELATED ARTICLES',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: MifcColors.white.withValues(alpha: 0.4),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
