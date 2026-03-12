import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';

class DiscussionHeader extends StatefulWidget {
  final int count;
  const DiscussionHeader({super.key, this.count = 48});

  @override
  State<DiscussionHeader> createState() => _DiscussionHeaderState();
}

class _DiscussionHeaderState extends State<DiscussionHeader> {
  bool _notifyReplies = true;
  String _sortBy = 'Top';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'DISCUSSION',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: MifcColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: MifcColors.crimson,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${widget.count}',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: MifcColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              _buildSortDropdown(),
            ],
          ),
        ),
        _buildNotificationToggle(),
        const Divider(color: MifcColors.border, height: 1),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: MifcColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MifcColors.white.withValues(alpha: 0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          dropdownColor: MifcColors.charcoal,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: MifcColors.white.withValues(alpha: 0.4), size: 16),
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: MifcColors.white,
            letterSpacing: 0.5,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) setState(() => _sortBy = newValue);
          },
          items: <String>['Top', 'Newest', 'Oldest']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toUpperCase()),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.7,
            alignment: Alignment.centerLeft,
            child: Switch(
              value: _notifyReplies,
              onChanged: (val) => setState(() => _notifyReplies = val),
              activeThumbColor: MifcColors.eliteBlue,
              activeTrackColor: MifcColors.eliteBlue.withValues(alpha: 0.2),
              inactiveThumbColor: MifcColors.white.withValues(alpha: 0.2),
              inactiveTrackColor: MifcColors.white.withValues(alpha: 0.05),
            ),
          ),
          Text(
            'Notify me when someone replies to my comment',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: MifcColors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

