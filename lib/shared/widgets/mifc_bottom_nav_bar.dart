import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/mifc_colors.dart';

class MifcBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MifcBottomNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    if (index == 4) {
      _showMoreMenu(context);
    } else {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MifcMoreMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex > 4 ? 0 : navigationShell.currentIndex,
      onDestinationSelected: (index) => _onTap(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.live_tv_outlined),
          selectedIcon: Icon(Icons.live_tv, color: Colors.white),
          label: 'MITV',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_outlined),
          selectedIcon: Icon(Icons.groups, color: Colors.white),
          label: 'Squad',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag, color: Colors.white),
          label: 'Store',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }
}

class MifcMoreMenu extends StatelessWidget {
  const MifcMoreMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MifcColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MifcColors.muted.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _buildMenuItem(Icons.how_to_vote, 'Polls & Fan Zone'),
          _buildMenuItem(Icons.sports_soccer, 'Fantasy XI'),
          _buildMenuItem(Icons.tv, 'MIFC TV'),
          _buildMenuItem(Icons.card_membership, 'Loyalty & Rewards'),
          _buildMenuItem(Icons.settings, 'Settings'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: MifcColors.navy),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: MifcColors.navyDark,
        ),
      ),
      onTap: () {},
    );
  }
}
