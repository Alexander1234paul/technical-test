import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/app_spacing.dart';

class PokeTextAtom extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final TextAlign textAlign;
  final bool uppercase;
  final int? maxLines;
  final TextOverflow overflow;
  final FontWeight? fontWeight;

  const PokeTextAtom({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.textAlign = TextAlign.center,
    this.uppercase = true,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    final effectiveFontSize =
        fontSize ??
        (media.size.width < 360
            ? 13
            : media.size.width > 600
            ? 18
            : 15);

    final effectiveColor = color ?? theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        style: AppTextStyle.body(context).copyWith(
          color: effectiveColor,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontSize: effectiveFontSize,
        ),
        child: Text(
          uppercase ? text.toUpperCase() : text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ),
    );
  }
}
