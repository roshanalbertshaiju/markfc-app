import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/mifc_colors.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'DISCUSSION',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: MifcColors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.count}',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: MifcColors.cardLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          dropdownColor: MifcColors.cardLight,
          icon: const Icon(Icons.expand_more, color: Colors.white54, size: 16),
          style: GoogleFonts.barlowCondensed(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) setState(() => _sortBy = newValue);
          },
          items: <String>['Top', 'Newest', 'Oldest']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.7,
            alignment: Alignment.centerLeft,
            child: Switch(
              value: _notifyReplies,
              onChanged: (val) => setState(() => _notifyReplies = val),
              activeColor: MifcColors.gold,
              activeTrackColor: MifcColors.gold.withOpacity(0.3),
              inactiveThumbColor: Colors.white54,
              inactiveTrackColor: Colors.white12,
            ),
          ),
          Text(
            'Notify me when someone replies to my comment',
            style: GoogleFonts.barlow(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: MifcColors.mutedOpacity,
            ),
          ),
        ],
      ),
    );
  }
}
