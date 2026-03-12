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
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80&w=1000',
    ),
    HeroSlide(
      tag: 'NEXT FIXTURE',
      date: 'SAT 14 MAR 2026 · 15:00',
      headline: 'MIFC VS MANCHESTER CITY',
      body: "Old Trafford · Premier League GW29 · Don't miss out",
      primaryButtonLabel: 'BOOK TICKETS',
      secondaryButtonLabel: 'KICK-OFF INFO',
      imageUrl: 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?auto=format&fit=crop&q=80&w=1000',
    ),
    HeroSlide(
      tag: 'MEMBERSHIP',
      date: '2025–26 SEASON',
      headline: 'BE PART OF SOMETHING BIGGER',
      body: 'Join thousands of passionate fans. Access exclusive content, priority tickets and loyalty rewards.',
      primaryButtonLabel: 'BECOME A MEMBER',
      secondaryButtonLabel: 'LEARN MORE',
      imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&q=80&w=1000',
    ),
    HeroSlide(
      tag: 'NEW KIT DROP',
      date: 'AVAILABLE NOW',
      headline: 'THE NEW 2025–26 HOME KIT IS HERE',
      body: 'Wear your colours with pride. Limited stock available — order yours today.',
      primaryButtonLabel: 'SHOP NOW',
      secondaryButtonLabel: 'VIEW COLLECTION',
      imageUrl: 'https://images.unsplash.com/photo-1570498839593-e565b39455fc?auto=format&fit=crop&q=80&w=1000',
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
            color: MifcColors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: MifcColors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'NEW 2025-26 KIT – NOW AVAILABLE!',
                    style: GoogleFonts.barlowCondensed(
                      color: MifcColors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: MifcColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    'SHOP NOW',
                    style: GoogleFonts.barlowCondensed(
                      color: MifcColors.red,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, color: MifcColors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() => _showAlert = false),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 450,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  // Restart timer on manual swipe to give user more time
                  _startTimer();
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return HeroSlideWidget(slide: _slides[index]);
                },
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) {
                    return Container(
                      width: index == _currentIndex ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? MifcColors.white
                            : MifcColors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
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
      children: [
        // Background Image with Gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [MifcColors.navy, MifcColors.navyDark],
            ),
          ),
          child: Opacity(
            opacity: 0.3,
            child: Image.network(
              slide.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Content
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48), // Bottom padding for dots
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MifcColors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  slide.tag,
                  style: GoogleFonts.barlowCondensed(
                    color: MifcColors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.date,
                style: GoogleFonts.barlowCondensed(
                  color: MifcColors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                slide.headline,
                style: GoogleFonts.barlowCondensed(
                  color: MifcColors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.body,
                style: GoogleFonts.barlow(
                  color: MifcColors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MifcColors.red,
                        foregroundColor: MifcColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        slide.primaryButtonLabel,
                        style: GoogleFonts.barlowCondensed(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MifcColors.white,
                        side: const BorderSide(color: MifcColors.white, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        slide.secondaryButtonLabel,
                        style: GoogleFonts.barlowCondensed(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
