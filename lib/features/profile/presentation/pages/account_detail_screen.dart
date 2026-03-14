import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';

class AccountDetailScreen extends StatelessWidget {
  final String title;
  final List<AccountOption> options;

  const AccountDetailScreen({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MifcColors.black,
      appBar: MifcTopBar(
        title: title,
        showBackButton: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: options.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withValues(alpha: 0.05),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: Icon(option.icon, color: MifcColors.prestigeGold, size: 22),
            title: Text(
              option.label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class AccountOption {
  final IconData icon;
  final String label;

  const AccountOption(this.icon, this.label);
}
