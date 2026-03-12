import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/mifc_colors.dart';

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
      height: 36,
      decoration: BoxDecoration(
        color: MifcColors.gold.withOpacity(0.06),
        border: Border(
          bottom: BorderSide(color: MifcColors.gold.withOpacity(0.12)),
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
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: MifcColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.count.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} fans reading this now',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: MifcColors.gold,
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
          width: 70,
          child: Stack(
            children: List.generate(4, (index) {
              return Positioned(
                left: index * 14.0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(color: MifcColors.navyDark, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials[index],
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: MifcColors.cardLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '+2k',
            style: TextStyle(fontSize: 8, color: Colors.white70, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
