import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markfc/features/profile/domain/models/mifc_user.dart';
import 'package:markfc/features/profile/domain/models/user_activity.dart';
import 'package:markfc/features/profile/data/repositories/profile_repository.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: MifcColors.black,
      body: userAsync.when(
        data: (rawUser) {
          final user = rawUser ?? MifcUser.guest();
          final isGuest = user.uid == 'guest';

          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      ScrollReveal(child: _MemberCard(user: user)),
                      const SizedBox(height: 32),
                      ScrollReveal(delay: const Duration(milliseconds: 100), child: _MemberStats(user: user)),
                      const SizedBox(height: 40),
                      if (isGuest)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: MifcColors.navyBlue.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: MifcColors.navyBlue.withValues(alpha: 0.1)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'UNLOCK ELITE BENEFITS',
                                  style: GoogleFonts.outfit(
                                    color: MifcColors.navyBlue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Join the Elite to earn loyalty points, access exclusive content, and more.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () => context.push('/login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MifcColors.navyBlue,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'LOG IN / REGISTER',
                                    style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Text(
                        'YOUR ACTIVITIES',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: MifcColors.navyBlue,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _ActivityList(uid: user.uid),
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
                      if (!isGuest)
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading profile: $err', style: const TextStyle(color: Colors.white70))),
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
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
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
  final MifcUser user;
  const _MemberCard({required this.user});

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
            MifcColors.navyBlue,
            MifcColors.black,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: MifcColors.navyBlue.withValues(alpha: 0.2),
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
              color: Colors.white.withValues(alpha: 0.03),
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
                        color: user.uid == 'guest' ? Colors.white.withValues(alpha: 0.1) : MifcColors.crimson,
                        borderRadius: BorderRadius.circular(30),
                        border: user.uid == 'guest' ? Border.all(color: Colors.white24, width: 1) : null,
                      ),
                      child: Text(
                        user.uid == 'guest' ? 'GUEST' : 'ELITE',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Icon(
                      user.uid == 'guest' ? Icons.lock_outline_rounded : Icons.qr_code_2_rounded, 
                      color: Colors.white, 
                      size: 28
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  user.uid == 'guest' ? 'JOIN THE ELITE' : user.name.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.uid == 'guest' ? 'CREATE AN ACCOUNT TO START' : 'MEMBER SINCE ${user.joinDate.year}',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.5),
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
  final MifcUser user;
  const _MemberStats({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('MATCHES', user.matchesAttended.toString()),
        _buildStatItem('LOYALTY', user.loyaltyPoints.toString()),
        _buildStatItem('YEARS', (DateTime.now().year - user.joinDate.year).toString()),
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

class _ActivityList extends ConsumerWidget {
  final String uid;
  const _ActivityList({required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (uid == 'guest') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.lock_person_rounded, color: Colors.white.withValues(alpha: 0.05), size: 40),
              const SizedBox(height: 12),
              Text(
                'LOGIN TO VIEW YOUR ACTIVITY',
                style: GoogleFonts.outfit(
                  color: Colors.white10,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final activitiesAsync = ref.watch(userActivitiesProvider(uid));
    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'NO RECENT ACTIVITIES',
                style: GoogleFonts.outfit(
                  color: Colors.white24,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          );
        }
        return Column(
          children: activities.map((activity) {
            final isLast = activities.last == activity;
            return Column(
              children: [
                _buildActivityItem(
                  _getIconForType(activity.type),
                  activity.title,
                  activity.subtitle,
                  _formatTime(activity.timestamp),
                ),
                if (!isLast) _buildDivider(),
              ],
            );
          }).toList(),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => const Text('Error loading activities', style: TextStyle(color: Colors.white38)),
    );
  }

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.purchase:
        return Icons.shopping_bag_rounded;
      case ActivityType.vote:
        return Icons.how_to_vote_rounded;
      case ActivityType.ticket:
        return Icons.confirmation_num_rounded;
      case ActivityType.other:
        return Icons.info_outline_rounded;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM').format(timestamp).toUpperCase();
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}D AGO';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}H AGO';
    } else {
      return 'JUST NOW';
    }
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
// Removed _UnauthenticatedView as it's now integrated into the main profile view
