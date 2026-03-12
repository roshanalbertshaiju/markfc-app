import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:markfc/core/theme/mifc_colors.dart';

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
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: MifcColors.black,
            border: const Border(top: BorderSide(color: MifcColors.border)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: MifcColors.navyBlue,
                child: Text(
                  'SB',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: MifcColors.black),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: MifcColors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MifcColors.white.withValues(alpha: 0.05)),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: GoogleFonts.inter(fontSize: 13, color: MifcColors.white),
                    decoration: InputDecoration(
                      hintText: 'Join the discussion...',
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: MifcColors.white.withValues(alpha: 0.3)),
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
                  color: _showEmojiPicker ? MifcColors.navyBlue : MifcColors.white.withValues(alpha: 0.3),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _showEmojiPicker = !_showEmojiPicker);
                  if (_showEmojiPicker) {
                    FocusScope.of(context).unfocus();
                  } else {
                    _focusNode.requestFocus();
                  }
                },
              ),
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: MifcColors.crimson,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: MifcColors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: emoji.EmojiPicker(
              onEmojiSelected: (category, em) {
                _controller.text += em.emoji;
              },
              config: emoji.Config(
                height: 250,
                checkPlatformCompatibility: true,
                emojiViewConfig: emoji.EmojiViewConfig(
                  backgroundColor: MifcColors.navyDark,
                  columns: 7,
                  emojiSizeMax: 28 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
                ),
                skinToneConfig: const emoji.SkinToneConfig(),
                categoryViewConfig: emoji.CategoryViewConfig(
                  backgroundColor: MifcColors.navyDark,
                  indicatorColor: MifcColors.navyBlue,
                  iconColorSelected: MifcColors.navyBlue,
                  backspaceColor: MifcColors.navyBlue,
                ),
                bottomActionBarConfig: const emoji.BottomActionBarConfig(
                  enabled: false,
                ),
                searchViewConfig: const emoji.SearchViewConfig(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReplyChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: MifcColors.charcoal,
      child: Row(
        children: [
          const Icon(Icons.reply_rounded, size: 14, color: MifcColors.navyBlue),
          const SizedBox(width: 12),
          Text(
            'REPLYING TO @${widget.replyTarget}'.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: MifcColors.navyBlue,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: widget.onCancelReply,
            child: Icon(Icons.close_rounded, size: 16, color: MifcColors.white.withValues(alpha: 0.3)),
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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)],
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
