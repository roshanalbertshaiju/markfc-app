import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';

class MifcTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MifcTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MifcColors.navyBlue,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      leadingWidth: 80, // Slightly narrower since it's vertical now
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: MifcColors.white,
                      size: 24,
                    ),
                    Positioned(
                      top: 2,
                      child: Container(
                        height: 4,
                        width: 14,
                        decoration: BoxDecoration(
                          color: MifcColors.crimson,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(1)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'KICK-OFF',
                  style: GoogleFonts.outfit(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: MifcColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/mifc_logo.png',
                height: 24,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'MARK INTERNATIONAL FC',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: MifcColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            'EST. 1878 · MANCHESTER',
            style: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: MifcColors.white.withValues(alpha: 0.6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: MifcColors.white, size: 24),
          onPressed: () {},
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: MifcColors.white, size: 24),
              onPressed: () {},
            ),
            Positioned(
              right: 14,
              top: 14,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: MifcColors.crimson,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
