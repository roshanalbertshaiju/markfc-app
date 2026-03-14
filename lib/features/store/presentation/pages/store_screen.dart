import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:markfc/shared/widgets/mifc_card.dart';
import 'package:markfc/shared/widgets/section_header.dart';
import 'package:markfc/shared/widgets/scroll_reveal.dart';
import '../providers/cart_provider.dart';
import '../../data/models/cart_item.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    double newOpacity = 0.0;

    if (offset <= 50) {
      newOpacity = 0.0;
    } else if (offset >= 200) {
      newOpacity = 1.0;
    } else {
      newOpacity = (offset - 50) / 150.0;
    }

    if (newOpacity != _appBarOpacity) {
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06080F),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeroBanner(),
                const SizedBox(height: 16),
                ScrollReveal(
                  child: const _SeasonKitSection(),
                ),
                const SizedBox(height: 24),
                ScrollReveal(
                  delay: const Duration(milliseconds: 100),
                  child: const _AccessoriesSection(),
                ),
                const SizedBox(height: 24),
                ScrollReveal(
                  delay: const Duration(milliseconds: 200),
                  child: const _TrainingWearSection(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MifcTopBar(opacity: _appBarOpacity),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Stadium Background
          Image.network(
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=2000',
            fit: BoxFit.cover,
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF06080F).withValues(alpha: 0.75),
                  Colors.transparent,
                  const Color(0xFF06080F).withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Store Info Text
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: MifcColors.navyBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: MifcColors.navyBlue.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.store_rounded, color: MifcColors.navyBlue, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'OFFICIAL STORE',
                        style: GoogleFonts.outfit(
                          color: MifcColors.navyBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '25/26 SEASON KIT COLLECTION',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Free delivery on orders over £60',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
// Private _SectionHeader removed in favor of shared SectionHeader

class _SeasonKitSection extends StatelessWidget {
  const _SeasonKitSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'MATCH KITS',
          onActionTap: () {},
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _KitCard(
                name: 'Home Kit',
                price: '£85',
                gradientColors: [Color(0xFF1A3070), Color(0xFF0D1B3E)],
                emoji: '👕',
                isNew: true,
                hasGoldBorder: true,
              ),
              const SizedBox(width: 12),
              _KitCard(
                name: 'Away Kit',
                price: '£80',
                gradientColors: [Color(0xFFD4A840), Color(0xFF8A6820)],
                emoji: '👕',
              ),
              const SizedBox(width: 12),
              _KitCard(
                name: 'Third Kit',
                price: '£80',
                gradientColors: [Color(0xFF2A0A2A), Color(0xFF8A1040)],
                emoji: '👕',
                isNew: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KitCard extends ConsumerWidget {
  final String name;
  final String price;
  final List<Color> gradientColors;
  final String emoji;
  final bool isNew;
  final bool hasGoldBorder;

  const _KitCard({
    required this.name,
    required this.price,
    required this.gradientColors,
    required this.emoji,
    this.isNew = false,
    this.hasGoldBorder = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MifcCard(
      width: 130,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      color: MifcColors.white.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  if (isNew)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: MifcColors.navyBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: GoogleFonts.outfit(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(cartProvider.notifier).addItem(
                          CartItem(
                            id: 'kit_$name',
                            name: name,
                            price: price,
                            emoji: emoji,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name added to cart'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: MifcColors.card,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    color: MifcColors.navyBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

class _AccessoriesSection extends StatelessWidget {
  const _AccessoriesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'ACCESSORIES',
          onActionTap: () {},
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const _AccessoryCard(name: 'Club Scarf', price: '£22', emoji: '🧣'),
              const SizedBox(width: 10),
              const _AccessoryCard(name: 'Snapback', price: '£28', emoji: '🧢'),
              const SizedBox(width: 10),
              const _AccessoryCard(name: 'Training Top', price: '£45', emoji: '👕'),
              const SizedBox(width: 10),
              const _AccessoryCard(name: 'Match Ball', price: '£35', emoji: '⚽'),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccessoryCard extends ConsumerWidget {
  final String name;
  final String price;
  final String emoji;

  const _AccessoryCard({
    required this.name,
    required this.price,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MifcCard(
      width: 90,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(14),
      color: MifcColors.white.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A1A),
                    Color(0xFF0F0F0F),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(cartProvider.notifier).addItem(
                          CartItem(
                            id: 'acc_$name',
                            name: name,
                            price: price,
                            emoji: emoji,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name added to cart'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: MifcColors.card,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    color: MifcColors.navyBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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
class _TrainingWearSection extends StatelessWidget {
  const _TrainingWearSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TrainingSectionHeader(),
        const SizedBox(height: 4),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              _TrainingCard(
                name: 'Training Jersey',
                price: '£45',
                emoji: '👕',
              ),
              SizedBox(width: 12),
              _TrainingCard(
                name: 'Training Shorts',
                price: '£30',
                emoji: '🩳',
              ),
              SizedBox(width: 12),
              _TrainingCard(
                name: 'Tracksuit',
                price: '£75',
                emoji: '👕',
              ),
              SizedBox(width: 12),
              _TrainingCard(
                name: 'Training Socks',
                price: '£12',
                emoji: '🧦',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrainingSectionHeader extends StatelessWidget {
  const _TrainingSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A840), // Gold
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'TRAINING WEAR',
              style: GoogleFonts.bebasNeue(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD4A840),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'SEE ALL →',
              style: GoogleFonts.barlowCondensed(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainingCard extends ConsumerWidget {
  final String name;
  final String price;
  final String emoji;

  const _TrainingCard({
    required this.name,
    required this.price,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MifcCard(
      width: 130,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      color: MifcColors.white.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F0F0F),
                    Color(0xFF050505),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(cartProvider.notifier).addItem(
                          CartItem(
                            id: 'training_$name',
                            name: name,
                            price: price,
                            emoji: emoji,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name added to cart'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: MifcColors.card,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.barlowCondensed(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.bebasNeue(
                    color: const Color(0xFFD4A840),
                    fontSize: 16,
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
