import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MifcColors.black,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const ScrollReveal(child: _MemberCard()),
                  const SizedBox(height: 32),
                  const ScrollReveal(delay: Duration(milliseconds: 100), child: _MemberStats()),
                  const SizedBox(height: 40),
                  Text(
                    'YOUR ACTIVITIES',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: MifcColors.prestigeGold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _ActivityList(),
                  const SizedBox(height: 40),
                  _buildSectionHeader('ACCOUNT'),
                  _buildAccountItem(
                    Icons.settings_outlined, 
                    'Settings',
                    onTap: () => context.push('/profile/settings'),
                  ),
                  _buildAccountItem(
                    Icons.help_outline_rounded, 
                    'Help & Support',
                    onTap: () => context.push('/profile/help'),
                  ),
                  _buildAccountItem(
                    Icons.logout_rounded, 
                    'Logout', 
                    isDestructive: true,
                    onTap: () => _showLogoutDialog(context),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MifcColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to log out of your Elite account?',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle actual logout logic here
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(color: MifcColors.crimson, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: MifcColors.black,
      expandedHeight: 0,
      centerTitle: false,
      title: Text(
        'MEMBER HUB',
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Colors.white.withValues(alpha: 0.3),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildAccountItem(
    IconData icon, 
    String title, 
    {required VoidCallback onTap, bool isDestructive = false}
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive 
              ? MifcColors.crimson.withValues(alpha: 0.1) 
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon, 
          color: isDestructive ? MifcColors.crimson : Colors.white, 
          size: 20
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: isDestructive ? MifcColors.crimson : Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
      onTap: onTap,
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0A0A0A),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MifcColors.prestigeGold.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: MifcColors.prestigeGold.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.stars_rounded,
              size: 200,
              color: MifcColors.prestigeGold.withValues(alpha: 0.03),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: MifcColors.prestigeGold,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'ELITE',
                        style: GoogleFonts.outfit(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Icon(Icons.qr_code_2_rounded, color: MifcColors.prestigeGold, size: 28),
                  ],
                ),
                const Spacer(),
                Text(
                  'ROSHAN ALBERT',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'MEMBER SINCE 2021',
                  style: GoogleFonts.inter(
                    color: MifcColors.prestigeGold.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberStats extends StatelessWidget {
  const _MemberStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('MATCHES', '12'),
        _buildStatItem('LOYALTY', '450'),
        _buildStatItem('YEARS', '3'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActivityItem(
          Icons.shopping_bag_rounded,
          'Kit Purchase',
          'Purchased 24/25 Home Kit',
          '2 days ago',
        ),
        _buildDivider(),
        _buildActivityItem(
          Icons.how_to_vote_rounded,
          'Fan Vote',
          'Voted for Player of the Month',
          '5 days ago',
        ),
        _buildDivider(),
        _buildActivityItem(
          Icons.confirmation_num_rounded,
          'Match Ticket',
          'Booked tickets for vs City',
          '1 week ago',
        ),
      ],
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white70, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              color: Colors.white24,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withValues(alpha: 0.05), height: 1);
  }
}
