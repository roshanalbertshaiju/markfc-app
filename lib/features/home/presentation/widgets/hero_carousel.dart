import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'dart:async';

class HeroSlide {
  final String tag;
  final String date;
  final String headline;
  final String body;
  final String primaryButtonLabel;
  final String secondaryButtonLabel;
  final String imageUrl;

  HeroSlide({
    required this.tag,
    required this.date,
    required this.headline,
    required this.body,
    required this.primaryButtonLabel,
    required this.secondaryButtonLabel,
    required this.imageUrl,
  });
}

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  bool _showAlert = true;
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  final List<HeroSlide> _slides = [
    HeroSlide(
      tag: 'MATCH REPORT',
      date: '04 MAR 2026',
      headline: 'THE REDS SECURE ANOTHER MASSIVE WIN…',
      body: 'A commanding performance at Old Trafford keeps the title dream very much alive heading into March.',
      primaryButtonLabel: 'READ REPORT',
      secondaryButtonLabel: 'VIEW GALLERY',
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=2000',
    ),
    HeroSlide(
      tag: 'NEXT FIXTURE',
      date: 'SAT 14 MAR 2026 · 15:00',
      headline: 'MIFC VS MANCHESTER CITY',
      body: "Old Trafford · Premier League GW29 · Don't miss out",
      primaryButtonLabel: 'BOOK TICKETS',
      secondaryButtonLabel: 'KICK-OFF INFO',
      imageUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?q=80&w=2000',
    ),
    HeroSlide(
      tag: 'MEMBERSHIP',
      date: '2025–26 SEASON',
      headline: 'BE PART OF SOMETHING BIGGER',
      body: 'Join thousands of passionate fans. Access exclusive content, priority tickets and loyalty rewards.',
      primaryButtonLabel: 'BECOME A MEMBER',
      secondaryButtonLabel: 'LEARN MORE',
      imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?q=80&w=2000',
    ),
    HeroSlide(
      tag: 'NEW KIT DROP',
      date: 'AVAILABLE NOW',
      headline: 'THE NEW 2025–26 HOME KIT IS HERE',
      body: 'Wear your colours with pride. Limited stock available — order yours today.',
      primaryButtonLabel: 'SHOP NOW',
      secondaryButtonLabel: 'VIEW COLLECTION',
      imageUrl: 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=2000',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < _slides.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showAlert)
          Container(
            color: MifcColors.eliteBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.star_outline, color: MifcColors.black, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'NEW 2025-26 KIT – NOW AVAILABLE',
                    style: GoogleFonts.outfit(
                      color: MifcColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showAlert = false),
                  child: const Icon(Icons.close, color: MifcColors.black, size: 14),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 480,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _startTimer();
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return HeroSlideWidget(slide: _slides[index]);
                },
              ),
              Positioned(
                bottom: 32,
                left: 24,
                child: Row(
                  children: List.generate(_slides.length, (index) {
                    return Container(
                      width: index == _currentIndex ? 32 : 8,
                      height: 2,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? MifcColors.eliteBlue
                            : MifcColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeroSlideWidget extends StatelessWidget {
  final HeroSlide slide;

  const HeroSlideWidget({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image with sophisticated overlay
        Image.network(
          slide.imageUrl,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 0.8, 1.0],
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.6),
                MifcColors.black,
              ],
            ),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                slide.tag.toUpperCase(),
                style: GoogleFonts.outfit(
                  color: MifcColors.eliteBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.headline,
                style: GoogleFonts.outfit(
                  color: MifcColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.body,
                style: GoogleFonts.inter(
                  color: MifcColors.white.withValues(alpha: 0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  _PrimaryButton(label: slide.primaryButtonLabel),
                  const SizedBox(width: 12),
                  _SecondaryButton(label: slide.secondaryButtonLabel),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  const _PrimaryButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: MifcColors.white,
        foregroundColor: MifcColors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  const _SecondaryButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: MifcColors.white,
        side: BorderSide(color: MifcColors.white.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
