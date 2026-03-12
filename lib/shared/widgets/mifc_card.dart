import 'package:flutter/material.dart';
import 'package:markfc/core/theme/mifc_colors.dart';

class MifcCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;
  final BorderRadius? borderRadius;
  final double elevation;
  final List<BoxShadow>? extraShadows;
  final VoidCallback? onTap;

  const MifcCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.elevation = 4.0,
    this.extraShadows,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? MifcColors.card.withValues(alpha: 0.8),
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        border: Border.all(
          color: MifcColors.border,
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
