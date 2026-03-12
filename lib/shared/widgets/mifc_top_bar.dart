import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/mifc_colors.dart';

class MifcTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MifcTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 56,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: MifcColors.white),
        onPressed: () {},
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
                height: 32, // More restrained, professional size
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text(
                'MARK INTERNATIONAL FC',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: MifcColors.white,
                ),
              ),
            ],
          ),
          Text(
            'EST. 1878 · MANCHESTER',
            style: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: MifcColors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: MifcColors.white),
          onPressed: () {},
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: MifcColors.white),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
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
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
