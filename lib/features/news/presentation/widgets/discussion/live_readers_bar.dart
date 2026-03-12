import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';

class LiveReadersBar extends StatefulWidget {
  final int count;
  const LiveReadersBar({super.key, this.count = 2847});

  @override
  State<LiveReadersBar> createState() => _LiveReadersBarState();
}

class _LiveReadersBarState extends State<LiveReadersBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: MifcColors.navyBlue.withValues(alpha: 0.04),
        border: Border(
          bottom: BorderSide(color: MifcColors.white.withValues(alpha: 0.05)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: MifcColors.navyBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.count.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} FANS READING NOW',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: MifcColors.navyBlue,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          _buildAvatarStack(),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    final colors = [Colors.amber, Colors.red, Colors.blue, Colors.green];
    final initials = ['AJ', 'MK', 'SR', 'PO'];
    
    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 24,
          child: Stack(
            children: List.generate(4, (index) {
              return Positioned(
                left: index * 12.0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(color: MifcColors.black, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials[index],
                    style: GoogleFonts.outfit(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: MifcColors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '+2K',
            style: GoogleFonts.outfit(
              fontSize: 9,
              color: MifcColors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
