import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/mifc_colors.dart';

class MifcTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MifcTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 70, // Slightly narrower
      leading: Padding(
        padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
        child: GestureDetector(
          onTap: () => context.push('/fixtures'),
          child: Container(
            decoration: BoxDecoration(
              color: MifcColors.eliteBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, size: 18, color: MifcColors.black),
                const SizedBox(height: 1),
                Text(
                  'KICK-OFF',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: MifcColors.black,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/mifc_logo.png',
            height: 48, // Increased size
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mark International',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                    color: MifcColors.white,
                    height: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'FC · MANCHESTER',
                  style: GoogleFonts.barlow(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: MifcColors.white.withValues(alpha: 0.8),
                    height: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          constraints: const BoxConstraints(maxWidth: 40),
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: MifcColors.crimson,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        IconButton(
          constraints: const BoxConstraints(maxWidth: 40),
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
