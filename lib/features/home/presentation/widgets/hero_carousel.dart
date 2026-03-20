import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markfc/core/theme/mifc_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markfc/features/home/domain/models/hero_slide.dart' as model;
import 'package:markfc/features/home/data/repositories/hero_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class HeroCarousel extends ConsumerStatefulWidget {
  const HeroCarousel({super.key});

  @override
  ConsumerState<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends ConsumerState<HeroCarousel> {
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final slidesAsync = ref.read(heroSlidesStreamProvider);
      final slidesCount = slidesAsync.value?.length ?? 0;
      
      if (slidesCount == 0) return;

      if (_currentIndex < slidesCount - 1) {
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
    final slidesAsync = ref.watch(heroSlidesStreamProvider);

    return slidesAsync.when(
      data: (slides) {
        if (slides.isEmpty) return const SizedBox.shrink();

        return SizedBox(
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
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  return HeroSlideWidget(slide: slides[index]);
                },
              ),
              Positioned(
                bottom: 32,
                left: 24,
                child: Row(
                  children: List.generate(slides.length, (index) {
                    return Container(
                      width: index == _currentIndex ? 32 : 8,
                      height: 2,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? MifcColors.navyBlue
                            : MifcColors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const _HeroShimmer(),
      error: (err, stack) => const _HeroErrorState(),
    );
  }
}

class _HeroShimmer extends StatelessWidget {
  const _HeroShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: double.infinity,
      color: MifcColors.navyBlue.withAlpha(13),
      child: const Center(
        child: CircularProgressIndicator(color: MifcColors.navyBlue),
      ),
    );
  }
}

class _HeroErrorState extends StatelessWidget {
  const _HeroErrorState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: double.infinity,
      color: MifcColors.navyBlue.withAlpha(26),
      child: const Center(
        child: Icon(Icons.error_outline, color: MifcColors.navyBlue),
      ),
    );
  }
}

class HeroSlideWidget extends StatelessWidget {
  final model.HeroSlide slide;

  const HeroSlideWidget({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image with sophisticated overlay and fallbacks
        CachedNetworkImage(
          imageUrl: slide.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: MifcColors.navyBlue.withAlpha(26),
            child: const Center(
              child: CircularProgressIndicator(color: MifcColors.white),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: MifcColors.navyBlue,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/launcher_icon.png', // Fallback to logo
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Center(
                  child: Icon(Icons.broken_image_outlined, color: MifcColors.white, size: 48),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.3, 0.7, 1.0],
              colors: [
                const Color(0xFF0D1B3E).withAlpha(179),
                const Color(0xFF0D1B3E).withAlpha(0),
                const Color(0xFF0D1B3E).withAlpha(0),
                const Color(0xFF0D1B3E).withAlpha(204),
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
                  color: MifcColors.navyBlue,
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
                  color: MifcColors.white.withAlpha(179),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: slide.buttons.isNotEmpty 
                  ? slide.buttons.map((btn) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _PrimaryButton(label: btn.label, link: btn.link),
                    )).toList()
                  : [
                      const _PrimaryButton(label: 'LEARN MORE', link: ''),
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
  final String link;
  const _PrimaryButton({required this.label, required this.link});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (link.isNotEmpty) {
          context.push(link);
        }
      },
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
