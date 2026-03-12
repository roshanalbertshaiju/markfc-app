import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/mifc_colors.dart';

class MifcTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MifcTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
        child: GestureDetector(
          onTap: () => context.push('/fixtures'),
          child: Container(
            decoration: BoxDecoration(
              color: MifcColors.gold,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, size: 20, color: MifcColors.navyDark),
                const SizedBox(height: 1),
                Text(
                  'KICK-OFF',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: MifcColors.navyDark,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      title: Column(
        children: [
          Text(
            'Mark International',
            style: GoogleFonts.barlowCondensed(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: MifcColors.white,
            ),
          ),
          Text(
            'FOOTBALL CLUB · MANCHESTER',
            style: GoogleFonts.barlow(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: MifcColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: MifcColors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
