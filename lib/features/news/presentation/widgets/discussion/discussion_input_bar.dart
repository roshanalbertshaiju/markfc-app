import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../../../core/theme/mifc_colors.dart';

class DiscussionInputBar extends StatefulWidget {
  final String? replyTarget;
  final VoidCallback onCancelReply;
  final Function(String) onSend;

  const DiscussionInputBar({
    super.key,
    this.replyTarget,
    required this.onCancelReply,
    required this.onSend,
  });

  @override
  State<DiscussionInputBar> createState() => _DiscussionInputBarState();
}

class _DiscussionInputBarState extends State<DiscussionInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false;
  bool _showMentionOverlay = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      if (text.endsWith('@')) {
        setState(() => _showMentionOverlay = true);
      } else if (!text.contains('@') || (text.contains('@') && !text.split(' ').last.startsWith('@'))) {
        if (_showMentionOverlay) setState(() => _showMentionOverlay = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend(_controller.text.trim());
      _controller.clear();
      if (_showEmojiPicker) setState(() => _showEmojiPicker = false);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showMentionOverlay) _buildMentionOverlay(),
        if (widget.replyTarget != null) _buildReplyChip(),
        
        Container(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: MifcColors.navyDark,
            border: Border(top: BorderSide(color: MifcColors.border)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 17,
                backgroundColor: MifcColors.gold,
                child: Text('SB', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: MifcColors.cardLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: GoogleFonts.barlow(fontSize: 14, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Join the discussion...',
                      hintStyle: GoogleFonts.barlow(fontSize: 14, color: Colors.white30),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _showEmojiPicker ? Icons.keyboard : Icons.sentiment_satisfied_alt_outlined,
                  color: _showEmojiPicker ? MifcColors.gold : Colors.white30,
                ),
                onPressed: () {
                  setState(() => _showEmojiPicker = !_showEmojiPicker);
                  if (_showEmojiPicker) FocusScope.of(context).unfocus();
                  else _focusNode.requestFocus();
                },
              ),
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: MifcColors.navy,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: MifcColors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _controller.text += emoji.emoji;
              },
              config: Config(
                backgroundColor: MifcColors.navyDark,
                indicatorColor: MifcColors.gold,
                iconColorSelected: MifcColors.gold,
                backspaceColor: MifcColors.gold,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                recentsLimit: 28,
                noRecents: const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReplyChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: MifcColors.navy,
      child: Row(
        children: [
          const Icon(Icons.reply, size: 14, color: MifcColors.gold),
          const SizedBox(width: 8),
          Text(
            'Replying to @${widget.replyTarget}',
            style: GoogleFonts.barlow(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MifcColors.gold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: widget.onCancelReply,
            child: const Icon(Icons.close, size: 14, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildMentionOverlay() {
    final users = [
      {'name': 'Adebayo James', 'initials': 'AJ'},
      {'name': 'Mohammed K.', 'initials': 'MK'},
      {'name': 'Sarah R.', 'initials': 'SR'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: MifcColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: users.map((user) => ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: MifcColors.navy,
            child: Text(user['initials']!, style: const TextStyle(fontSize: 8, color: Colors.white)),
          ),
          title: Text(user['name']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
          onTap: () {
            setState(() {
              final text = _controller.text;
              _controller.text = text.replaceRange(text.lastIndexOf('@') + 1, text.length, '${user['name']} ');
              _showMentionOverlay = false;
            });
          },
        )).toList(),
      ),
    );
  }
}
