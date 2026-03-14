import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const NotificationCenter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF06080F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              children: [
                const _NotificationGroupHeader(title: 'TODAY'),
                const ScrollReveal(
                  child: _NotificationItem(
                    type: NotificationType.match,
                    title: 'GOAL! MARK INT 1-0 CHELSEA',
                    subtitle: 'Mohamed Salah (12\') clinical finish from the edge of the box.',
                    time: '12 MINS AGO',
                    isLive: true,
                  ),
                ),
                const ScrollReveal(
                  delay: Duration(milliseconds: 100),
                  child: _NotificationItem(
                    type: NotificationType.store,
                    title: 'EXCLUSIVE: TRAINING WEAR DROP',
                    subtitle: 'The new Elite Performance range is now available in the store.',
                    time: '2 HOURS AGO',
                  ),
                ),
                const _NotificationGroupHeader(title: 'YESTERDAY'),
                const ScrollReveal(
                  delay: Duration(milliseconds: 200),
                  child: _NotificationItem(
                    type: NotificationType.news,
                    title: 'PRESS CONFERENCE: MANAGER UPDATES',
                    subtitle: 'Latest injury updates and tactical insights before the weekend clash.',
                    time: '1 DAY AGO',
                  ),
                ),
                const ScrollReveal(
                  delay: Duration(milliseconds: 300),
                  child: _NotificationItem(
                    type: NotificationType.match,
                    title: 'MATCH REVIEW: GRIMSBY 2-2 MARK INT',
                    subtitle: 'Dive deep into the tactical analysis of Saturday\'s draw.',
                    time: '1 DAY AGO',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 12, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ACTIVITY HUB',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

enum NotificationType { match, news, store }

class _NotificationItem extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String subtitle;
  final String time;
  final bool isLive;

  const _NotificationItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B3E).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          if (isLive)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: MifcColors.crimson,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        time,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: type == NotificationType.match 
                            ? MifcColors.crimson 
                            : const Color(0xFFD4A840),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.match:
        icon = Icons.sports_soccer_rounded;
        color = MifcColors.crimson;
        break;
      case NotificationType.news:
        icon = Icons.newspaper_rounded;
        color = Colors.blueAccent;
        break;
      case NotificationType.store:
        icon = Icons.shopping_bag_rounded;
        color = const Color(0xFFD4A840);
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _NotificationGroupHeader extends StatelessWidget {
  final String title;
  const _NotificationGroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Colors.white.withValues(alpha: 0.3),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
