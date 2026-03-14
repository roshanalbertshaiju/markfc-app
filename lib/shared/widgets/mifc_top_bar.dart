import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import '../../features/store/presentation/providers/cart_provider.dart';

class MifcTopBar extends StatelessWidget implements PreferredSizeWidget {
  final double opacity;
  const MifcTopBar({super.key, this.opacity = 1.0});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D1B3E).withValues(alpha: opacity),
      elevation: opacity * 4,
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light, // White icons for Android
        statusBarBrightness: Brightness.dark, // White icons for iOS
      ),
      leadingWidth: 76, // Restored to provide enough space for KICK-OFF icon
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2C48D).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.sports_soccer_rounded,
                      color: Color(0xFFE2C48D), // Prestige Gold
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Matches',
                  style: GoogleFonts.outfit(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: const Color(0xFFE2C48D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/mifc_logo.png',
              height: 56,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MARK INT',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    color: MifcColors.white,
                  ),
                ),
                Text(
                  'FOOTBALL CLUB',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4.0,
                    color: MifcColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: MifcColors.white, size: 24),
          onPressed: () {},
        ),
        // Cart Icon with Badge
        Consumer(
          builder: (context, ref, child) {
            final cartCount = ref.watch(cartCountProvider);
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: MifcColors.white, size: 24),
                  onPressed: () {
                    // Navigate to cart or show summary
                  },
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC9A84C),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
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
