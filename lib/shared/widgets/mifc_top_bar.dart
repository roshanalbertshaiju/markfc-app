import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/shared/widgets/promotional_header.dart';
import '../../core/theme/mifc_colors.dart';

class MifcTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MifcTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PromotionalHeader(),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 64, // Slightly taller for more presence
          leadingWidth: 56,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded, color: MifcColors.white, size: 28),
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
                    height: 24, // Consistent size
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
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140); // 64 (Toolbar) + ~70 (Promotion + Safe Area)
}
