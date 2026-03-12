import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollReveal extends StatefulWidget {
  final Widget child;
  final AnimationType type;
  final Duration? delay;
  final Duration? duration;

  const ScrollReveal({
    super.key,
    required this.child,
    this.type = AnimationType.fadeSlide,
    this.delay,
    this.duration,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

enum AnimationType {
  fade,
  slide,
  scale,
  fadeSlide,
  fadeScale,
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _isVisible = false;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          if (mounted) {
            setState(() => _isVisible = true);
          }
        }
      },
      child: _isVisible
          ? _buildAnimatedChild()
          : Opacity(opacity: 0, child: widget.child),
    );
  }

  Widget _buildAnimatedChild() {
    var effect = widget.child.animate();
    
    final delay = widget.delay ?? 0.ms;
    final duration = widget.duration ?? 400.ms;

    switch (widget.type) {
      case AnimationType.fade:
        effect = effect.fadeIn(delay: delay, duration: duration);
        break;
      case AnimationType.slide:
        effect = effect.slideY(begin: 0.05, end: 0, delay: delay, duration: duration, curve: Curves.easeOut);
        break;
      case AnimationType.scale:
        effect = effect.scaleXY(begin: 0.95, end: 1.0, delay: delay, duration: duration, curve: Curves.easeOut);
        break;
      case AnimationType.fadeSlide:
        effect = effect
            .fadeIn(delay: delay, duration: duration)
            .slideY(begin: 0.1, end: 0, delay: delay, duration: duration, curve: Curves.easeOut);
        break;
      case AnimationType.fadeScale:
        effect = effect
            .fadeIn(delay: delay, duration: duration)
            .scaleXY(begin: 0.9, end: 1.0, delay: delay, duration: duration, curve: Curves.easeOut);
        break;
    }

    return effect;
  }
}
