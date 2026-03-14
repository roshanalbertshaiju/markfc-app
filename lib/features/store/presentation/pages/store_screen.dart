import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/shared/widgets/mifc_top_bar.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06080F),
      appBar: const MifcTopBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _HeroBanner(),
            const SizedBox(height: 32),
            const _SeasonKitSection(),
            const SizedBox(height: 40),
            const _AccessoriesSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B3E), Color(0xFF06080F)],
        ),
      ),
      child: Stack(
        children: [
          // Subtle radial gold glow
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFC9A84C).withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A84C).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0xFFC9A84C).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  'OFFICIAL STORE',
                  style: GoogleFonts.barlowCondensed(
                    color: const Color(0xFFC9A84C),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '25/26 SEASON\nKIT COLLECTION',
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 48,
                  height: 0.9,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Free delivery on orders over £60',
                style: GoogleFonts.barlowCondensed(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeasonKitSection extends StatelessWidget {
  const _SeasonKitSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'MATCH KITS',
            style: GoogleFonts.bebasNeue(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: const [
              _KitCard(
                name: 'HOME KIT',
                price: '£85',
                gradientColors: [Color(0xFF0D1B3E), Color(0xFF06080F)],
                emoji: '👕',
                isNew: true,
                isFeatured: true,
              ),
              SizedBox(width: 16),
              _KitCard(
                name: 'AWAY KIT',
                price: '£80',
                gradientColors: [Color(0xFFE2C48D), Color(0xFFC9A84C)],
                emoji: '👕',
                textColor: Color(0xFF06080F),
              ),
              SizedBox(width: 16),
              _KitCard(
                name: 'THIRD KIT',
                price: '£80',
                gradientColors: [Color(0xFF9D1C1E), Color(0xFF0D1B3E)],
                emoji: '👕',
                isNew: true,
              ),
              SizedBox(width: 16),
              _KitCard(
                name: 'TRAINING KIT',
                price: '£45',
                gradientColors: [Color(0xFF1A1A1A), Color(0xFF333333)],
                emoji: '🎽',
              ),
              SizedBox(width: 16),
              _KitCard(
                name: 'GK KIT',
                price: '£90',
                gradientColors: [Color(0xFF3CB371), Color(0xFF2E8B57)],
                emoji: '🧤',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KitCard extends StatelessWidget {
  final String name;
  final String price;
  final List<Color> gradientColors;
  final String emoji;
  final bool isNew;
  final bool isFeatured;
  final Color? textColor;

  const _KitCard({
    required this.name,
    required this.price,
    required this.gradientColors,
    required this.emoji,
    this.isNew = false,
    this.isFeatured = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFeatured 
            ? const Color(0xFFC9A84C).withValues(alpha: 0.35)
            : Colors.white.withValues(alpha: 0.07),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
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
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9A84C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: GoogleFonts.barlowCondensed(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.barlowCondensed(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.bebasNeue(
                    color: const Color(0xFFC9A84C),
                    fontSize: 20,
                    letterSpacing: 0.5,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACCESSORIES',
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                'VIEW ALL →',
                style: GoogleFonts.barlowCondensed(
                  color: const Color(0xFFC9A84C),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: const [
              _AccessoryCard(name: 'CLUB SCARF', price: '£22', emoji: '🧣'),
              SizedBox(width: 12),
              _AccessoryCard(name: 'SNAPBACK', price: '£28', emoji: '🧢'),
              SizedBox(width: 12),
              _AccessoryCard(name: 'TRAINING TOP', price: '£45', emoji: '👕'),
              SizedBox(width: 12),
              _AccessoryCard(name: 'WATER BOTTLE', price: '£12', emoji: '🍼'),
              SizedBox(width: 12),
              _AccessoryCard(name: 'FC BACKPACK', price: '£55', emoji: '🎒'),
              SizedBox(width: 12),
              _AccessoryCard(name: 'CLUB KEYRING', price: '£5', emoji: '🔑'),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccessoryCard extends StatelessWidget {
  final String name;
  final String price;
  final String emoji;

  const _AccessoryCard({
    required this.name,
    required this.price,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.barlowCondensed(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            price,
            style: GoogleFonts.bebasNeue(
              color: const Color(0xFFC9A84C),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
